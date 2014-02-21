WhiteCollar::Application.routes.draw do
  root :to => "tickets#index"  
  
  post "users/assign_teacher_to_section"
  get  "users/create_new_section"
  get  "users/teachers"
  get  "users/student_manager"
  get  "users/student_rep"
  post "users/input_students_parse"
  get  "users/settings"
  get  "projects/next_step"
  post "projects/change_project"
  post "/users/change_student_status"
  post "/users/show_section"
  post "projects/select_project"
  post "/users/set_section"
  match  "receipts/my_receipts/:id", to: 'receipts#my_receipts', via: 'get'
  post "users/need_help"
  get  "clients/submit"
  post "/clients/approve_client"
  post "/clients/approve_client_edit"
  post "/clients/disapprove_client"
  get "reports/student_summary"
  get "reports/activities"
  get "reports/sales"
  get "reports/team_summary"

  resources :sessions, only: [:new, :create, :destroy]
  resources :tickets
  resources :clients
  resources :projects
  resources :users
  resources :receipts do
    resources :actions 
  end
  
  resources :actions
  
  match '/signin', to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'
  match 'receipts/index/user', to: 'receipts#index', via: 'get'

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
