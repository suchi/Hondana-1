class BookshelfController < ApplicationController
  def search
    query = params[:query]
    if query =~ /^\s*$/ then
      redirect_to :action => 'list'
      return
    else
      # 100件に限る
      books = Book.where("authors like ? or title like ?", "%#{query}%", "%#{query}%").limit(100)
    end
    render locals: { query: query, books: books }
  end

  def list
    newentries = Entry.limit(10).where.not(:comment => "").order("modtime DESC") # _deletedな本棚の本も見えてしまう? まぁ良いか??
    dispshelves = Shelf.limit(15).order("modtime DESC").where.not("name like '%_deleted%'")
    rand = Shelf.order("random()").limit(10) # .where.not("name like '%_deleted%'")

    render locals: { newentries: newentries, dispshelves: dispshelves, rand: rand }
  end
  
  def create
    # redirect_to :action => 'list'
    shelfname = params[:shelfname]
    challenge = params[:challenge]
    response = params[:response]
    puts "shelfname=#{shelfname}, challenge=#{challenge}, response=#{response}"
    if challenge != response then
      redirect_to :action => 'list'
    else
      #if shelfname == '' || shelfname.index('<') || shelfname =~ /%3c/i ||
      #    shelfname =~ /^[\d\w]{32}$/ ||
      #    shelfname =~ /Ita7ef/ ||
      #    (shelfname =~ /^[\d\w]{16}$/ && shelfname =~ /[a-z]/ && shelfname =~ /[A-Z]/) ||
      #    cookies[:List] != 'Hondana' ||
      #    cookies[:Hondana] != 'xxxx' then
      #  redirect_to :action => 'list'
      #else
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
      #end
    end
  end
end
