# -*- coding: utf-8 -*-
module ShelfHelper
  @@IMAGEPAT = /\.(jpg|jpeg|png|gif|tif|tiff)$/i
  @@HTMLPAT = /^(http|https|mailto|ftp):/
  @@ISBNPAT = /\d{9}[0-9X]/
  @@CGIPAT = /\w+\.cgi$/

  def expand_tag___(s,shelfname)
    s = s.to_s.
        gsub(/<(\/?(b|i|br|p|ul|ol|li|dl|dt|dd|hr|pre|blockquote|del))/i,'LBRA!\1!').
        gsub(/</,'&lt;').
        gsub(/LBRA!([^!]*)!/,'<\1').
        gsub(/\[\[([^\]]*)\]\]/){ link($1,shelfname.to_s) }
  end

  def expand_tag(s,shelfname)
    s = s.to_s.
        gsub(/<(\/?(b|i|br|p|ul|ol|li|dl|dt|dd|hr|pre|blockquote|del))>/i,'LBRA!\1!>').
        gsub(/</,'&lt;').
        gsub(/LBRA!([^!]*)!/,'<\1').
        gsub(/\[\[([^\]]*)\]\]/){ link($1,shelfname.to_s) }
  end

  def link(s,shelfname)
    s =~ /^(\S+)\s*(.*)$/
    name = $1
    desc = origdesc = $2
    desc = name if desc == ''
    case name
    when @@HTMLPAT then # URLへのリンク
      "<a href=\"#{name}\">#{desc}</a>"
    when @@ISBNPAT
      name =~ /^((.*):)?(#{@@ISBNPAT})$/
      shelfname = ($2.to_s == '' ? shelfname : $2.to_s)
      isbn = $3
      # book = Book.find(:first, :conditions => ['isbn = ?',isbn])
      book = Book.where(:isbn => isbn)[0]
      if book.nil? then
        link_to '('+isbn+'登録)', :shelfname => shelfname, :action => 'newbooks', :isbn => isbn
      else
        link_to origdesc!='' ? desc : book.title, :shelfname => shelfname, :action => 'edit', :isbn => isbn
      end
    when /^(.+):$/
      shelfname = $1
      if origdesc == '' then
        desc = "#{shelfname}の本棚"
      end
      link_to desc, :shelfname => shelfname, :action => 'show'
    when /^(.*)\?$/
      q = $1
      link_to q, :controller=> 'bookshelf', :action => 'search', :q => q
    else
      # link_to desc, :controller => 'search', :action => 'searchone', :q => name, :shelfname => shelfname
      #link_to desc, :action => 'search', :q => name
      link_to desc, :controller=> 'bookshelf', :action => 'search', :q => desc
    end
  end
end

if $0 == __FILE__ then
  include ShelfHelper
  puts expand_tag("abc<d>efg",'xxx')
  puts expand_tag("abc<dd>efg",'xxx')
  puts expand_tag("abc<ddd>efg",'xxx')
  puts expand_tag("abc<d >efg",'xxx')
  puts expand_tag("abc<dd >efg",'xxx')
  puts expand_tag("abc<ddd >efg",'xxx')
  s = "そもそもユーザは何を求めてるのかよく考えろ、と言ってるだけに聞こえる...<br>各事例は面白いのだが、それをまとめた「理論」など意味があるのだろうか? <p> 「そもそもから考える」ことを「ジョブ」という言葉を使っているだけである。マットレスを買った人の話があったが、<a 'bcd'>彼はマットレスが欲しかったのではなくて快眠が欲しかっただけだ、みたいな。これいったことを「快眠というジョブをハイアする」のように表現しており、そういう考えを「ジョブ理論」と呼んでいるようだ。 <br> そういう考え方は正しいだろうが理論というほどのものか? あたりまえではないのか??"
  puts expand_tag(s,'xxx')
end
