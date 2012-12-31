require 'sinatra'
require 'sinatra/activerecord'
require 'kaminari'
require 'kaminari/sinatra'

configure do
  set :database, 'sqlite3:///db/development.sqlite3'
end

class Entry < ActiveRecord::Base
end

helpers Kaminari::Helpers::SinatraHelpers
helpers do
  def bk_link(link)
    url = URI.parse(link)
    url.scheme = nil
    path = url.to_s.sub(/^\/+/, '')
    '%s/%s' % ['http://b.hatena.ne.jp/entry', path]
  end
end

get '/' do
  @entries = Entry.order('date DESC').page(params[:page])
  erb :index
end

__END__

@@layout
<!doctype html>
<html>
<head>
  <meta charset="UTF-8">
  <title>hatebu-news-clone</title>
  <style>
body {
  font-family: 'Helvetica', 'Arial', 'ヒラギノ角ゴ Pro W3', 'Hiragino Kaku Gothic Pro', 'メイリオ', Meiryo, 'ＭＳ Ｐゴシック', 'MS PGothic', sans-serif;
  line-height: 1.8em;
}

a {
  text-decoration: none;
}
#main {
  margin: 30px;
}
.bk {
  color: #F00;
  background-color: #FCC;
}
.date {
  color: #0A0;
}
  </style>
</head>
<body>
  <div id="main">
    <h3>hatebu-news-clone</h3>
    <%= yield %>
  </div>
</body>
</html>

@@index
<% @entries.each do |e| %>
  <div>
    <span class="date"><%= e.date %></span>
    <a href="<%= e.link %>"><%= e.title %></a>
    <strong><a class="bk" href="<%= bk_link(e.link) %>"><%= e.bk_count %> users</a></strong>
  </div>
<% end %>

<%= paginate @entries, :first => nil, :last => nil %>
