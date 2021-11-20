Rails.application.routes.draw do
  namespace :identification do
    resources :business_license_identification do
      post :identify, on: :collection
    end
  end
end
