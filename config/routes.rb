Rails.application.routes.draw do
  post 'identify', to: 'contacts#identify'
end
