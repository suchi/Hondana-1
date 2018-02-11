Rails.application.routes.draw do
  # match ':controller(/:action(/:id))(.:format)' => 'welcome#index', :via => :get
  # match ':shelfname' => 'shelf#show', :via => :get

  root :to => 'bookshelf#list'
  
  # 各本棚トップ
  # app/controllers/shelf_controller.rb
  # app/views/shelf/show.html.erb
  get ':shelfname' => 'shelf#show'
  get ':shelfname/' => 'shelf#show'

  # 書籍編集ページ
  get ':shelfname/:isbn' => 'shelf#edit', constraints: { isbn: /\d{9}[\dX]/ }
  
  # カテゴリ表示
  get ':shelfname/category' => 'shelf#category'

  # 書込み
  post ':shelfname/write' => 'shelf#write'

  # controller という名前は特別なのかも?
  match ':controller/:action', :via => :get

  # 詳細: http://guides.rubyonrails.org/routing.html
end
