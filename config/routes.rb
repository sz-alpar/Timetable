Timetable::Application.routes.draw do
  get "teacher/index"

  root :to => 'login#index'
  
  match "/login" => "login#index", :as => "login"
  match "/login/verify" => "login#verify", :as => "login_verify", :via => :post
  match "/logout" => "login#destroy", :as => "logout"
  
  match "/admin" => "admin#index", :as => "admin"
  match "/admin/new_teacher" => "teacher#new_teacher", :as => "admin_new_teacher"
  match "/admin/save_teacher" => "teacher#save_teacher", :as => "admin_save_teacher", :via => :post
  match "/admin/edit_teacher/show" => "teacher#edit_teacher", :as => "admin_show_edit_teacher"
  match "/admin/edit_teacher/:id" => "teacher#edit_teacher", :as => "admin_edit_teacher"
  match "/admin/delete_teacher/:id" => "teacher#delete_teacher", :as => "admin_delete_teacher"
  
  match "/admin/edit_timesheet" => "timesheets#edit", :as => "admin_edit_timesheet"
  match "/admin/save_timesheet" => "timesheets#save", :as => "admin_save_timesheet"
  match "/admin/timesheet" => "timesheets#index", :as => "admin_timesheet"
  
  match "/teacher" => "teacher#index", :as => "teacher"
  match "/teacher/timesheet/:id" => "timesheets#index", :as => "teacher_timesheet"
  
  resources :users, :courses, :course_types, :hours, :teaches, :roles, :wishes, :timesheets

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
  # root :to => 'login#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
