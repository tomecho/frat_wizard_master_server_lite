Rails.application.routes.draw do
  resources :groups
  post '/verify_facebook', to: 'application#verify_facebook_token'

  get '/location/within', to: 'location#within'
  resources :location, except: %i(update)

  get '/user/:id/location', to: 'user#location'
  resources :user, except: %i(delete create)

  resources :orgs
end
