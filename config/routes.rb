Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'


  
  namespace :staffs do
    resources :bases
  end
  resources :staffs

  
  namespace :base do
    resources :items,:factories,:fees,:steeltypes
  end
  namespace :project do
    #income_costs icosts
    resources :incomes do
      get 'original',on: :member
      post 'original'=>'incomes#original!',on: :member
    end

    resources :trucks,:costs,:fees,:icosts,:search,:audit,:finance,:infos
  end



  get 'session/login'
  post 'session/login' => 'session#login!'
  
  get 'session/timeout'
  post 'session/timeout' => 'session#timeout!'

  get 'session/deny'
  get 'session/logout'
  get 'session/forgetpasswd'
  post 'session/resetpasswd'

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
