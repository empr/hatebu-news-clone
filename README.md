# hatebu-news-clone

Clone of [Hatena Bookmark News](http://labs.ceek.jp/hbnews/).


## Usage

1. install gems

       bundle install --path vendor/bundle

1. create database

       rake db:migrate

1. insert data to database

       bundle exec ruby script/job.rb

1. run server

       bundle exec ruby app.rb
