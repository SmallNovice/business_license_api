Rails.application.routes.draw do
  namespace :identification do
    resources :business_license_identification do
      get 'identify', on: :collection
    end
  end
end
