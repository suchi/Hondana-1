Rails.application.routes.draw do
  # match ':controller(/:action(/:id))(.:format)' => 'welcome#index', :via => :get
  # match ':shelfname' => 'shelf#show', :via => :get

  # resources :posts
  #get 'atom' => 'bookshelf#atom'
  
  # resources :bookshelf
  root :to => 'bookshelf#list'

  # ファイルの中のパスワードとクイズを変換してをDBにコピー
  get 'convert_db' => 'shelf#convert_db'

  # ATOM
  # get 'atom.xml' => 'bookshelf#atom'

  # 各本棚トップ
  # app/controllers/shelf_controller.rb
  # app/views/shelf/show.html.erb
  get ':shelfname' => 'shelf#show', constraints: { shelfname: /[^\/]+/ } # ドットを含む本棚名を許す
  get ':shelfname/' => 'shelf#show', constraints: { shelfname: /[^\/]+/ }

  # 本棚作成
  post 'bookshelf/create' => 'bookshelf#create'

  # 本棚検索
  post 'bookshelf/shelfsearch' => 'bookshelf#shelfsearch'

  # 書籍編集ページ
  get ':shelfname/:isbn' => 'shelf#edit', constraints: { shelfname: /[^\/]+/, isbn: /\d{9}[\dX]/ }
  
  # カテゴリ表示
  get ':shelfname/category' => 'shelf#category', constraints: { shelfname: /[^\/]+/ }

  # ヘルプ
  get ':shelfname/help' => 'shelf#help', constraints: { shelfname: /[^\/]+/ }

  # データリスト
  get ':shelfname/datalist' => 'shelf#datalist', constraints: { shelfname: /[^\/]+/ }

  # 書籍削除
  post ':shelfname/delete' => 'shelf#delete', constraints: { shelfname: /[^\/]+/ }
  post ':shelfname/realdelete' => 'shelf#realdelete', constraints: { shelfname: /[^\/]+/ }

  # 新規登録
  get ':shelfname/newbooks' => 'shelf#newbooks', constraints: { shelfname: /[^\/]+/ }

  # 本棚情報編集
  get ':shelfname/profile_edit' => 'shelf#profile_edit', constraints: { shelfname: /[^\/]+/ }
  post ':shelfname/profile_write' => 'shelf#profile_write', constraints: { shelfname: /[^\/]+/ }

  # 本棚名変更
  get ':shelfname/rename' => 'shelf#rename', constraints: { shelfname: /[^\/]+/ }
  post ':shelfname/setname' => 'shelf#setname', constraints: { shelfname: /[^\/]+/ }

  # 新規登録
  post ':shelfname/add' => 'shelf#add', constraints: { shelfname: /[^\/]+/ }

  # 書込み
  post ':shelfname/write' => 'shelf#write', constraints: { shelfname: /[^\/]+/ }

  # 検索
  post 'bookshelf/search' => 'bookshelf#search'

  # カテゴリ編集
  get ':shelfname/category_bookselect' => 'shelf#category_bookselect', constraints: { shelfname: /[^\/]+/ }
  post ':shelfname/category_bookset' => 'shelf#category_bookset', constraints: { shelfname: /[^\/]+/ }

  get ':shelfname/category_detail' => 'shelf#category_detail', constraints: { shelfname: /[^\/]+/ }
  get ':shelfname/category_simple' => 'shelf#category_simple', constraints: { shelfname: /[^\/]+/ }
  get ':shelfname/category_rename' => 'shelf#category_rename', constraints: { shelfname: /[^\/]+/ }
  post ':shelfname/category_setname' => 'shelf#category_setname', constraints: { shelfname: /[^\/]+/ }

  # controller という名前は特別なのかも?
  match ':controller/:action', :via => :get

  # 詳細: http://guides.rubyonrails.org/routing.html

end
