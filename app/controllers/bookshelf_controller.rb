class BookshelfController < ApplicationController
  def search
    query = params[:query]
    if query =~ /^\s*$/ then
      redirect_to :action => 'list'
      return
    else
      # 100件に限る
      books = Book.where("authors like ? or title like ?", "%#{query}%", "%#{query}%").limit(100)
      # コメントの中も検索したいかも
    end
    render locals: { query: query, books: books }
  end

  def list
    newentries = Entry.limit(10).where.not(:comment => "").order("modtime DESC") # _deletedな本棚の本も見えてしまう? まぁ良いか??
    dispshelves = Shelf.limit(15).order("modtime DESC").where.not("name like '%_deleted%'")
    rand = Shelf.order("random()").limit(10) # .where.not("name like '%_deleted%'")

    render locals: { newentries: newentries, dispshelves: dispshelves, rand: rand }
  end
  
  def shelfsearch
    query = params[:query]
    newentries = Entry.limit(10).where.not(:comment => "").order("modtime DESC") # _deletedな本棚の本も見えてしまう? まぁ良いか??
    dispshelves = Shelf.limit(15).where("name like '%#{query}%'").where.not("name like '%_deleted%'").order("modtime DESC")
    rand = Shelf.order("random()").limit(10).where.not("name like '%_deleted%'")

    render :action => 'list', locals: { newentries: newentries, dispshelves: dispshelves, rand: rand }
  end
  
  def create
    # redirect_to :action => 'list' # 本棚作成を許さない場合

    shelfname = params[:shelfname]
    challenge = params[:challenge]
    response = params[:response]
    ansmd5 = params[:ansmd5]

    require "digest/md5"
    #if Math.sqrt(challenge.to_i).floor != response.to_i then # 平方根認証
    if Digest::MD5.hexdigest(response) != ansmd5 then
      redirect_to :action => 'list'
    else
      shelf = Shelf.where(name: shelfname)[0]
      if shelf.nil? then
        shelf = Shelf.new
        shelf.name = shelfname
        shelf.description = ''
        shelf.url = ''
        shelf.affiliateid = ''
        shelf.theme = ''
        shelf.themeurl = ''
        shelf.listtype = 'image'
        shelf.sorttype = 'recent'
        shelf.modtime = Time.now
        shelf.save
      end
      redirect_to :controller => 'shelf', :action => 'show', :shelfname => shelfname
    end
  end

  def atom
    # 意味わからないが、こういうの用意すると views/bookshelf/atom.xml.erb が使える
    respond_to do |format|
      format.xml
    end
  end
end

