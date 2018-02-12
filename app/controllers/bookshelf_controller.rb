class BookshelfController < ApplicationController
  def search
    query = params[:query]
    if query =~ /^\s*$/ then
      redirect_to :action => 'list'
      return
    else
      books = Book.where("authors like ? or title like ?", "%#{query}%", "%#{query}%")
    end

    render locals: { query: query, books: books }
  end

  def list
    newentries = Entry.limit(10).where.not(:comment => "").order("modtime DESC") # _deletedな本棚の本も見えてしまう? まぁ良いか??
    dispshelves = Shelf.limit(15).order("modtime DESC").where.not("name like '%_deleted%'")
    rand = Shelf.order("random()").limit(10) # .where.not("name like '%_deleted%'")

    render locals: { newentries: newentries, dispshelves: dispshelves, rand: rand }
  end
end
