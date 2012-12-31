require 'active_record'
require 'nokogiri'
require 'open-uri'
require 'date'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => '%s/development.sqlite3' % File.expand_path(File.join(File.dirname(__FILE__), '../db'))
)

class Entry < ActiveRecord::Base
end

URL = 'http://b.hatena.ne.jp/entrylist?sort=hot&threshold=7&mode=rss'

def fetch
  open(URL).read
end

def parse(rss)
  items = []
  doc = Nokogiri::XML.parse(rss)
  doc.css('item').each {|e|
    items << {
      :link => e.css('link').text,
      :title => e.css('title').text,
      :bk_count => e.css('hatena|bookmarkcount').text.to_i,
      :date => DateTime.parse(e.css('dc|date').text)
    }
  }
  items
end

def update(items)
  items.each {|i|
    entry = Entry.where(:link => i[:link]).first
    if entry
      if entry.bk_count != i[:bk_count]
        entry.bk_count = i[:bk_count]
        entry.save
      end
    else
      Entry.create(
        :link => i[:link],
        :title => i[:title],
        :bk_count => i[:bk_count],
        :date => i[:date]
      )
    end
  }
end

def main
  rss = fetch
  items = parse(rss)
  update(items)
end

if __FILE__ == $0
  main
end
