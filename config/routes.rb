# frozen_string_literal: true

Rails.application.routes.draw do
  get '*path', to: 'application#fallback', constraints: ->(request) do
    !request.xhr? && request.format.html?
  end

  scope '/api', defaults: { format: :json } do
    namespace :v1 do
      resources :zones, only: [:index]
      resources :geojson_features, only: [:index]
      resources :tweets, only: [:index]
      get '/zones/charts_data', to: 'zones#charts_data'
      get '/zones/raw-data', to: 'zones#raw_data'
      post '/contact', to: 'contacts#contact'
    end
  end

end
