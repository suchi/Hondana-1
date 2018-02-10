class ShelfController < ApplicationController
  def show
    shelf = getshelf
    if shelf.nil? then
      redirect_to :controller => 'bookshelf', :action => 'list'
      return
    end

    # e.g. http://hondana.org/増井?page=5&list=image&sort=score
    shelf.listtype = params[:list] || shelf.listtype || 'image'   # image / text / dtail
    shelf.sorttype = params[:sort] || shelf.sorttype || 'recent'  # recent / score
    shelf.save

    render locals: { shelf: shelf, entries: entries(shelf) }
  end

  def edit
    shelf = getshelf
    book = getbook
    entry = getentry(shelf,book)
    
    render locals: { shelf: shelf, book: book, entry: entry }
  end

  def category
    shelf = getshelf
    # logger.debug "Category: shelf=#{shelf}"
    shelf.listtype = params[:list]

    categories = Set.new
    shelf.entries.each { |entry|
      entry.categories.split(/,\s*/).each { |category|
        categories.add category if category != ''
      }
    }
    render locals: { shelf: shelf, categories: categories.to_a.sort }
  end

  private
  
  def entries(shelf)
    per_page = (shelf.listtype == 'image' ? 60 : shelf.listtype == 'text' ? 200 : 20)
    sort = (shelf.sorttype == 'recent' ? "modtime DESC" : "score DESC")
    Entry.where(shelf_id: shelf.id).order(sort).paginate(:page => params[:page], :per_page => per_page)
  end
  
  def getshelf
    shelfname = params[:shelfname]
    Shelf.where(name: shelfname)[0]
  end

  def getbook
    params[:isbn] =~ /\d{9}[\dX]/
    isbn = $&
    Book.where(isbn: isbn)[0]
  end

  def getentry(shelf, book)
    logger.debug "shelf = #{shelf} book = #{book}"
    Entry.where("shelf_id = ? and book_id = ?", shelf.id, book.id)[0]
  end
end
