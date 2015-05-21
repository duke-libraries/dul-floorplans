Rails.application.routes.draw do

  get 'floorplans/view'
  resources :floorplans
  
  resources :rooms

  get 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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

  get 'admin' => 'admin#index'

  namespace :admin do
    get 'admin/index'
    resources :buildings
    resources :floorplans do
      post 'add_floor_area' => 'floorplans#add_floor_area'
    end
    resources :rooms do
      post 'add_room_area' => 'rooms#add_room_area'
    end
    resources :rooms
    resources :room_areas
  end
  
  ## External URL references
  get "/support" => redirect("http://library.duke.edu/support"), :as => :support_home
  get "/featured-story" => redirect("http://library.duke.edu/crazy-smart"), :as => :featured_story
  get "/giving-opportunities" => redirect("http://library.duke.edu/support/giving-opportunities"), :as => :giving_opportunities
  get "/friends" => redirect("http://library.duke.edu/support/friends"), :as => :friends_of_libraries
  get "/news" => redirect("http://blogs.library.duke.edu"), :as => :news_and_events
  get "/how-to-give" => redirect("http://library.duke.edu/support/how-give"), :as => :how_to_give
  get "/give-now" => redirect("https://www.gifts.duke.edu/library"), :as => :give_now
  get "/contact" => redirect("http://library.duke.edu/support/contact"), :as => :contact
end
