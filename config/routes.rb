Rails.application.routes.draw do
  # Api 
  namespace :api, defaults: { format: :json } do
    namespace :v1 do

    end
  end
end
