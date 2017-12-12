SponsoredApplications::Engine.routes.draw do
  get "broker/:broker_id/sponsor/:sponsor_id", to: "sponsored_applications#new", as: "broker_quote_creation"
  resources :sponsored_applications
end
