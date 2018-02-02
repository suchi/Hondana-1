class ShelfController < ApplicationController
  def show
    shelf = getshelf
    if shelf.nil? then
      redirect_to :controller => 'bookshelf', :action => 'list'
      return
    end

    # e.g. http://hondana.org/増井?page=5&list=image&sort=score
    shelf.listtype = params[:list] || shelf.listtype || 'image'
    shelf.sorttype = params[:sort] || shelf.sorttype || 'recent'
    shelf.save

    render locals: { shelf: shelf, entries: entries(shelf) }
  end

  def entries(shelf)
    per_page = (shelf.listtype == 'image' ? 60 : shelf.listtype == 'text' ? 200 : 20)
    sort = (shelf.sorttype == 'recent' ? "modtime DESC" : "score DESC")
    Entry.where(:shelf_id => shelf.id).order(sort).paginate(:page => params[:page], :per_page => per_page)
  end
  
  private
  def getshelf
    shelfname = params[:shelfname]
    Shelf.where(name: shelfname)[0]
  end
end
