Rails.application.routes.draw do
  resources :zones, only: [:index]
  resources :geojson_features, only: [:index]
  resources :tweets, only: [:index]
end
