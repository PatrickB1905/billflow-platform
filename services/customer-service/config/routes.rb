Rails.application.routes.draw do
  # Swagger UI & JSON
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  # Auth & customers
  post '/auth/login', to: 'authentication#login'
  resources :customers
end