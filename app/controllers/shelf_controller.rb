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

    #case shelf.listtype
    #when 'text'
    #  case shelf.sorttype
    #  when 'score'
    #    show_score_text
    #    render :action => 'show_score_text'
    #  else
    #    show_recent_text
    #    render :action => 'show_recent_text'
    #  end
    #when 'detail'
    #  case shelf.sorttype
    #  when 'score'
    #    show_score_detail
    #    render :action => 'show_score_detail'
    #  else
    #    show_recent_detail
    #    render :action => 'show_recent_detail'
    #  end
    #else
    #  if shelf.sorttype == 'score' then
    #    show_score_image
    #    render :action => 'show_score_image'
    #  else
    #   #entries = show_recent_image shelf
    #
    #    e = entries('image', shelf, 60)
    #    # render :action => 'show_recent_image', locals: { shelf: shelf, entries: e }
    #    render :action => 'show', locals: { shelf: shelf, entries: e }
    #
    #    # params[:shelf] = shelf
    #    # params[:entries] = e
    #    # 自動で render show されるか
    #  end
    #end
  end

  def ___entries(type, shelf, per_page)
    Entry.where(:shelf_id => shelf.id).order("modtime DESC").paginate(:page => params[:page], :per_page => per_page)
  end

  # def entries(shelf, listtype, sorttype)
  def entries(shelf)
    per_page = (shelf.listtype == 'image' ? 60 : shelf.listtype == 'text' ? 200 : 20)
    sort = (shelf.sorttype == 'recent' ? "modtime DESC" : "score DESC")
    Entry.where(:shelf_id => shelf.id).order(sort).paginate(:page => params[:page], :per_page => per_page)
  end
  
  #def show_recent(type, shelf, per_page)
  #  shelf.listtype = type
  #  shelf.sorttype = 'recent'
  #  # shelf.save
  #
  #  # :conditionというのが使えなくなった模様
  #  Entry.where(:shelf_id => shelf.id).order("modtime DESC").paginate(:page => params[:page], :per_page => per_page)
  #end
  #
  #def show_recent_image(shelf)
  #  show_recent('image',shelf,60)
  #end

  private
  def getshelf
    shelfname = params[:shelfname]
    Shelf.where(name: shelfname)[0]
  end
end
