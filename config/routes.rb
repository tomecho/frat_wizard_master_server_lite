Rails.application.routes.draw do
  resources :groups
  post '/verify_facebook', to: 'application#verify_facebook_token'

  get '/location/within', to: 'location#within'
  resources :location, except: %i(update)

  get '/user/:id/location', to: 'user#location'
  post '/user/use_org_claim_code', to: 'user#use_org_claim_code'
  resources :user, except: %i(delete create)

  resources :orgs, except: %i(new edit)
  resources :org_claim_codes, only: %i(show create destroy)
end
