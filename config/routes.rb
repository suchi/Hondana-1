Rails.application.routes.draw do
  #
  # 各本棚表示
  #
  # app/views/shelf/show.html.erb
  # app/controllers/shelf_controller.rb
  match ':shelfname' => 'shelf#show', :via => :get
  match ':shelfname/' => 'shelf#show', :via => :get

  match ':shelfname/:isbn' => 'shelf#edit', :via => :get
  
  match ':shelfname/category' => 'shelf#category', :via => :get
  
  # match ':controller(/:action(/:id))(.:format)' => 'welcome#index', :via => :get
  # controller という名前は特別なのかも
  
  match ':controller/:action', :via => :get

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
