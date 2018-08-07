#
# ローカルにRailsを走らせる
# データベースはHerokuのを使う
#
run:
	DATABASE_URL=`heroku config -a hondana-heroku | grep DATABASE_URL | ruby -n -e 'puts $$_.split[1]'` rails server

restart:
	heroku restart -a hondana-heroku

stop:
	heroku ps:scale web=0 -a hondana-heroku
#	heroku ps:scale web=1 -a hondana-heroku
