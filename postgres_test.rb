require 'pg'
require 'rails'
require 'rails_12factor'

# connection = PG::connect(:host => "localhost", :user => "masui", :password => "",  :dbname => "hondana", :port => 5432)
# begin
#   # connection を使い PostgreSQL を操作する
#   # ...
# ensure
#   # データベースへのコネクションを切断する
#   connection.finish
#   exit
# end

require 'active_record'

config = {
  adapter: 'postgresql',
  host: 'localhost',
  database: 'hondana',
  port: 5432,
  username: 'masui',
  password: '',
  encoding: 'utf8',
  timeout: 5000
}

p config

ActiveRecord::Base.establish_connection(config)

