Rails.application.routes.draw do
  post '/verify_facebook', to: 'application#verify_facebook_token'

  get '/location/within', to: 'location#within'
  resources :location, except: %i(update)

  get '/user/:id/location', to: 'user#location'
  resources :user, except: %i(delete)

  resources :event
  resources :orgs # this should probably be singular

end
