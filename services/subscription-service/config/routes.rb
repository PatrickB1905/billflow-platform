Rails.application.routes.draw do
  # Swagger UI & JSON endpoints
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  post '/auth/login', to: 'authentication#login'
  resources :plans
  resources :subscriptions do
    member { get :dry_run }
  end
end
