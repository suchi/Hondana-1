#
# ローカルにRailsを走らせる
# データベースはHerokuのを使う
#

# heroku config はherokuが動いているときでないと駄目っぽいので環境変数にも用意しておく
run:
	DATABASE_URL=$(DATABASE_URL) rails server
#	DATABASE_URL=`heroku config -a hondana-heroku | grep DATABASE_URL | ruby -n -e 'puts $$_.split[1]'` rails server

restart:
	heroku restart -a hondana-heroku

stop:
	heroku ps:scale web=0 -a hondana-heroku
#	heroku ps:scale web=1 -a hondana-heroku
