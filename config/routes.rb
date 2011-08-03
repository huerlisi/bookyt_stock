Rails.application.routes.draw do
  # Assets
  resources :stocks do
    collection do
      get :write_downs
    end
  end

  resources :invoices do
    resources :stocks
  end
end
