Rails.application.routes.draw do
  Rails.application.routes.draw do
    namespace :api do
      namespace :v1 do
        resources :shops do
          resources :products
          resources :orders
        end

        resources :products
        resources :orders
      end
    end
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
end
