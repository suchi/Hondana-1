class BookshelfController < ApplicationController
  def search
  end

  def list
    newentries = Entry.limit(10).where.not(:comment => "").order("modtime DESC") # 10件だけ
    # _deletedな本棚の本も見えてしまう?

    render locals: { newentries: newentries }
  end
end
