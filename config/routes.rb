Rails.application.routes.draw do
  get '/', to: 'welcome#index'
  get 'forecast', to: 'weather_forecast#forecast_by_address'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
