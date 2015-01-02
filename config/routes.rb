Rails.application.routes.draw do
  root to: 'portfolios#index'
  
  get 'signup', to: 'admins#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'rss', to: 'portfolios#rss', as: 'rss', :defaults => { :format => 'rss' }
  get 'csv', to: 'portfolios#csv', as: 'csv', :defaults => { :format => 'csv' }
  get 'pdf', to: 'portfolios#pdf', as: 'pdf'
  get 'json', to: 'portfolios#json', as: 'json', :defaults => { :format => 'json' }
  get 'protected' => 'portfolios#protected'
  post 'password_submit' => 'portfolios#password_submit'
  resources :admins, except: [:show, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :tags, except: [:show, :edit, :new]
  resources :columns, only: [:update], :path => 'column' do
    post 'toggle_show' => 'columns#toggle_show'
    post 'change_position' => 'columns#change_position'
    resources :entries, :path => 'entry', only: [:new, :create]
  end
  resources :portfolios, except: [:edit, :show], :path => ''
  resources :entries, except: [:new, :create, :index], param: :title do
    post 'change_column' => 'entries#change_column'
  end


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
