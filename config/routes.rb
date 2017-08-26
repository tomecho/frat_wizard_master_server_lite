Rails.application.routes.draw do
  post '/verify_facebook', to: 'application#verify_facebook_token'

  get '/location/within', to: 'location#within'
  resources :location, except: %i(update)

  get '/user/:id/location', to: 'user#location'
  post '/user/:id/use_org_claim_code', to: 'user#use_org_claim_code'
  resources :user, except: %i(delete create)

  resources :orgs, except: %i(new edit)
  resources :org_claim_codes, only: %i(show create destroy)

  post '/group/:id/add_user', to: 'group#add_user'
  delete '/group/:id/remove_user', to: 'group#remove_user'
  post '/group/:id/add_permission', to: 'group#add_permission'
  delete '/group/:id/remove_permission', to: 'group#remove_permission'
  resources :groups, except: %i(edit new)
end
