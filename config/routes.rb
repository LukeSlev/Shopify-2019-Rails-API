# config/routes.rb
Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :shops do
        resources :products
        resources :orders do
          resources :line_items
        end
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
