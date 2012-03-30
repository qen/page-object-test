PageObjectApi::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  match     '/api/pages/published',       :to => 'api#get_published',    :as => :'published_api_pages',    :defaults => {:format => :'json'}, :via => :get
  match     '/api/pages/unpublished',     :to => 'api#get_unpublished',  :as => :'unpublished_api_pages',  :defaults => {:format => :'json'}, :via => :get

  # register resource here
  resources :page, :path => '/api/pages', :controller => :api,  :as => :'api_pages',            :defaults => {:format => :'json'}
  #match     '/api/pages/:get',        :to => :api, :constraints => {:get => /^(un)?published$/ },  :defaults => {:format => :'json'}

  match     '/api/pages/:id/total_words', :to => 'api#get_total_words',  :as => :'total_words_api_page',   :defaults => {:format => :'json'}, :via => :get
  match     '/api/pages/:id/publish',     :to => 'api#do_publish',       :as => :'publish_api_pages',      :defaults => {:format => :'json'}, :via => :post
  
  
end
