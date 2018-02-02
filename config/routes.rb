Rails.application.routes.draw do
  match 'xxx' => 'welcome#index', :via => :get

  match 'disp/:type/:price' => 'welcome#index', :via => :get
  
  match ':shelf' => 'shelf#show', :via => :get

  # match ':controller(/:action(/:id))(.:format)' => 'welcome#index', :via => :get
  # controller という名前は特別なのかも
  
  match ':controller/:action', :via => :get

  #get 'welcome/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
