LetterThief::Engine.routes.draw do
  resources :email_messages, only: [:index, :show]
end
