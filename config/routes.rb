Rails.application.routes.draw do
  get '/location/within', to: 'location#within'
  resources :location, except: %i(update)

  get '/user/:id/location', to: 'user#location'
  resources :user, except: %i(delete)

  resources :orgs
end
