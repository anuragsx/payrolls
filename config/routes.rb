Payrolls::Application.routes.draw do

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


  resources :oauth_clients

  match 'oauth/test_request' => 'oauth#test_request', :as => :test_request

  match 'oauth/access_token' => 'oauth#access_token', :as => :access_token

  match 'oauth/request_token' => 'oauth#request_token', :as => :request_token

  match 'oauth/authorize' => 'oauth#authorize', :as => :authorize

  match 'oauth/revoke' => 'oauth#revoke', :as => :revoke

  match 'oauth' => 'oauth#index'


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



  resources :incentives do
    collection do
      get 'bulk'
      post 'bulk_create'
      get 'detailed_info'
    end
  end


  resources :arrears do
    collection do
      get 'bulk'
      post 'bulk_create'
    end
  end

  resources :tds_returns

  resources :company_grades
  resource :bank

  resources :feedbacks

  root :to => "user_sessions#index"

  #root :to => "home#index"

  resources :users do
    member do
      post 'swap_user_status'
      get 'send_email'
    end
  end

  resource :user_session

  match 'logout' => "user_sessions#destroy", :as => :logout

  resources :expense_claims do
    collection do
      get 'bulk'
      post 'bulk_create'
      get 'detailed_info'
    end
  end

  resources :employees do

    collection do
      post 'import'
      get 'new_import'
      post 'bulk_create'
    end

    member do
      get 'new_resign'
      get 'new_activate'
      get 'new_suspend'
      match 'identity_card'
      put 'resign'
      put 'suspend'
      put 'activate'
    end

    resources :loans, :has_many => :emi_overrides
    resources :expense_claims
    resources :insurances
    resources :advances
    resources :salary_slips
    resources :bonus, :only => [:index, :show]
    resources :leaves
    resource :leave_balances do
      collection do
        post 'bulk_update'
      end
    end
    resources :employee_packages do
      member do
        get 'ctc'
      end
    end

    resources :esis

    resources :pfs do
      member do
        get 'exit'
      end
    end

    resource :tax_details
    resources :incentives
    resources :labour_welfares, :only => [:index]

    resource :professional_tax do
      member do
        post 'deregister'
      end
    end

    resources :attendances
    resources :ltas
    resources :arrears
  end


    resources :taxes

    resources :investments
    resources :other_incomes






    resources :lta_claims


  resource :company_leave do
    member do
      post 'forward_leaves'
    end
  end

  resource :company_esi
  resource :company_pf

  resources :salary_slips do


    member do
      get 'send_email'
    end
  end

  #resources :packages, :has_many => :accounts

  resources :packages do
    resources :accounts
  end

  resources :salary_sheets do
    member do
      get 'bank_statement'
      get 'send_email'
      get 'send_sms'
      get 'head_view'
    end

    collection do
      get 'graph'
      get 'graph_data'
    end


    resources :insurances do
      collection do
        get 'premium'
        get 'bulk'
      end

    end


    resources :loans do
      collection do
        get 'emis'
        post 'bulk_create'
        get 'bulk'
      end
    end

    resources :expense_claims, :only => [:index], :new => {:bulk => :get}
    resources :advances, :only => [:index], :new => {:bulk => :get}
    resources :leaves, :only => [:index], :new => {:bulk => :get}
    resource :income_tax, :only => [:none] do
      collection do
        get 'tds_challan'
      end
    end
    resources :professional_taxes,:only => [:index]
    resources :salary_slips,:only => [:index]
    resources :incentives, :only => [:index], :new => {:bulk => :get}
    resources :arrears, :only => [:index], :new => {:bulk => :get}

  end




  resources :accounts do
    collection do
      get 'welcome'
      match 'check_subdomain'
      get 'activate'
      get 'resend_email'
    end

  end

  resources :departments
  resources :employees

  resources :company_calculators, :only => [:index, :update]

  resources :company_allowance_heads,:only => [:index, :create]

  resources :reset_passwords

  resources :companies, :except => [:index, :new] do
     member do
       put 'delete_logo'
       get 'calculators'
     end

  end

  resources :loans do
    collection do
      get 'emi_sheet'
    end

  end

  resources :insurances do
    get 'bulk'
    collection do
      post 'bulk_create'
    end
  end

  resources :advances do
    get 'bulk'
    collection do
      post 'bulk_create'
    end
  end

  resources :bonus do
    collection do
      get 'settings'
    end
  end


  resources :esis do
    member do
      get 'challan'
    end
  end

  resources :gratuities, :only => [:index, :show]

  resources :pfs do
    member do
      get 'form5'
      get 'form12a'
      get 'form10'
      get 'form2'
      get 'challan'
    end
  end

  resources :company_loadings

  resources :company_flexi_packages

  resources :income_taxes do
    collection do
      get 'slabs'
    end
  end

  resource :home, :only => :show

  resources :leaves, :only => :index do
    collection do
      get 'detailed_info'
      get 'bulk'
      get 'excel_bulk'
      post 'bulk_create'
      post 'excel_bulk_create'
    end
  end

  resources :labour_welfares
  resources :labour_welfare_categories, :only => :index do
    member do
      get 'slabs'
    end
  end

  resources :professional_taxes, :only => :index
  resource :company_professional_tax
  resources :attendances, :only => :index do
    member do
      get 'bulk'
      post 'bulk_create'
    end
  end

  resources :payments
  #Translate::Routes.translation_ui(map) if Rails.env.development?

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
