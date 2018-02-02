class ShelfController < ApplicationController
  def show
    shelf = getshelf
    if shelf.nil? then
      redirect_to :controller => 'bookshelf', :action => 'list'
      return
    end

    case shelf.listtype
    when 'text'
      case shelf.sorttype
      when 'score'
        show_score_text
        render :action => 'show_score_text'
      else
        show_recent_text
        render :action => 'show_recent_text'
      end
    when 'detail'
      case shelf.sorttype
      when 'score'
        show_score_detail
        render :action => 'show_score_detail'
      else
        show_recent_detail
        render :action => 'show_recent_detail'
      end
    else
      case shelf.sorttype
      when 'score'
        show_score_image
        render :action => 'show_score_image'
      else
        entries = show_recent_image shelf
        render :action => 'show_recent_image', locals: { shelf: shelf, entries: entries }
      end
    end
  end

  def show_recent(type, shelf, per_page)
    shelf.listtype = type
    shelf.sorttype = 'recent'
    # shelf.save

    # :conditionというのが使えなくなった模様
    Entry.where(:shelf_id => shelf.id).order("modtime DESC").paginate(:page => params[:page], :per_page => per_page)
  end

  def show_recent_image(shelf)
    show_recent('image',shelf,60)
  end

  private
  def getshelf
    shelfname = params[:shelfname]
    Shelf.where(name: shelfname)[0]
  end
end
