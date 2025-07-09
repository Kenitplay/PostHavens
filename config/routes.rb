Rails.application.routes.draw do
  devise_for :admins

  root 'posts#index'

  resources :posts do
    collection do
      get 'search'
    end
  end

  resource :site_settings, only: [:edit, :update]

end
