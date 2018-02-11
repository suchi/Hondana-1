class BookshelfController < ApplicationController
  def search
  end

  def list
    newentries = Entry.limit(10).where.not(:comment => "").order("modtime DESC") # 10件だけ
    # _deletedな本棚の本も見えてしまう?
    dispshelves = Shelf.limit(15).order("modtime DESC") # .where.not("NOT name like '%_deleted%'")

    render locals: { newentries: newentries, dispshelves: dispshelves }
  end
end
