Rails.application.routes.draw do

  mount Notifier::Engine => "/notifier"

  devise_for :users, :controllers => { :sessions => 'users/sessions', :passwords => 'users/passwords' }

  root 'welcome#index'
end
