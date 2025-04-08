LetterThief::Engine.routes.draw do
  resources :email_messages, only: [:index, :show, :destroy]
  root "email_messages#index"
end
