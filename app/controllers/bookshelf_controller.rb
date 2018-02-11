class BookshelfController < ApplicationController
  def search
  end

  def list
    # newentries = Entry.find(:all, :order => "modtime DESC", :limit => 10, :conditions => "NOT comment = ''")
    # newentries = Entry.where(:all, ).order => "modtime DESC", :limit => 10, :conditions => "NOT comment = ''")
    newentries = Entry.order("modtime DESC")[0..9]
    # _deletedな本棚の本も見えてしまう?

    render locals: { newentries: newentries }
  end
end
