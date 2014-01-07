Railscalc::Application.routes.draw do
  post 'calculate' => "calculations#create", :as => 'calculations'
  root 'calculations#new'
end
