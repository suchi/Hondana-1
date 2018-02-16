class Time
  def rsstime
    strftime("%Y-%m-%dT%H:%M:%SZ")
  end
end

# createdはFeedValidatorに怒られるのだが

class Atom
  def Atom.xmlhead
    <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<?xml-stylesheet href="http://www.blogger.com/styles/atom.css" type="text/css"?>
EOF
  end

  def Atom.head(params)
    <<EOF
<title>#{params['title']}</title>
<subtitle>#{params['subtitle']}</subtitle>
<tagline mode="escaped" type="text/html">#{params['description']}</tagline>
<id>#{params['id']}</id>
<link rel="alternate" href="#{params['link']}" title="#{params['title']}" type="application/atom+xml"/>
<author><name>#{params['author']}</name></author>
<updated>#{params['updated'].rsstime}</updated>
<created>#{params['updated'].rsstime}</created>
EOF
  end

  def Atom.entry(params)
    <<EOF
<entry>
<title>#{params['title']}</title>
<link rel="alternate" href="#{params['link']}" title="#{params['title']}" type="application/atom+xml" />
<id>#{params['id']}</id>
<published>#{params['published'].rsstime}</published>
<author><name>#{params['author']}</name></author>
<updated>#{params['updated'].rsstime}</updated>
<created>#{params['updated'].rsstime}</created>
<category scheme="http://xmlns.com/wordnet/1.6/" term="#{params['category']}"/>
<summary>#{params['summary']}</summary>
<content type="xhtml">
<div xmlns="http://www.w3.org/1999/xhtml">
<p>
<a href="#{params['link']}"><img src="#{params['image']}" /></a>
</p>
</div>
</content>
</entry>
EOF
  end

  def Atom.atom
    out = ''
    out = Atom.xmlhead + "\n\n"
    
    headparams = {}
    headparams['title'] = '本棚.org'
    headparams['subtitle'] = '書籍情報共有サイト'
    headparams['description'] = '書籍情報共有サイト'
    headparams['id'] = 'tag:www.hondana.org,2005:hondana'
    headparams['link'] = 'http://hondana.org/'
    headparams['author'] = 'Hondana.org'
    headparams['updated'] = Time.now
    headparams['modified'] = Time.now
    
    out += <<EOF
<feed xmlns="http://www.w3.org/2005/Atom">
EOF
    
    out += Atom.head(headparams)
    
    newentries = Entry.limit(20).order("modtime DESC")
    newentries[0..20].each { |entry|
      shelf = entry.shelf
      book = entry.book
      
      entryparams = {}
      s = book.title.to_s
      s.gsub!(/\&/,"&amp;")
      s.gsub!(/"/,"&quot;")
      s.gsub!(/</,"&lt;")
      s.gsub!(/>/,"&gt;")
      entryparams['title'] = s
      
      entryparams['link'] = "/#{shelf.name}/#{book.isbn}"
      entryparams['id'] = "tag:hondana.org,2005:#{shelf.id}-#{book.isbn}"
      entryparams['published'] = book.modtime
      entryparams['author'] = shelf.name
      entryparams['issued'] = book.modtime
      entryparams['updated'] = book.modtime
      entryparams['category'] = 'Books'
      s = entry.comment.to_s
      s.gsub!(/[\r\n]/,'')
      s.gsub!(/\&/,"&amp;")
      s.gsub!(/"/,"&quot;")
      s.gsub!(/</,"&lt;")
      s.gsub!(/>/,"&gt;")
      entryparams['summary'] = s
      entryparams['image'] = book.imageurl
      out += Atom.entry(entryparams)
    }
    
    out += <<EOF
</feed>
EOF
    out
  end
end
