WebadapterPrototype::Application.routes.draw do

  devise_for :users

  resources :sites do
    get 'page/:page', :action => :index, :on => :collection
    match 'api/:name', :to => "api_methods#call", :as => 'api_method_call'

    resources :api_methods do
      member do
        get 'call'
      end

      resources :versions do
        member do
          put 'restore'
        end
      end

      resources :alarms
    end

    member do
      put :archive
      put :unarchive
    end

    collection do
      get :archived
    end

  end

  resources :users do
    member do
      put :disable
      put :enable
    end
  end

  resources :alarms

  root :to => 'sites#index'
end
