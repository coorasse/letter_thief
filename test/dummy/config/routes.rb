Rails.application.routes.draw do
  mount LetterThief::Engine => "/letter_thief"

  root to: "home#show"

  get "send_text_mail", to: "home#send_text_mail"
  get "send_html_mail", to: "home#send_html_mail"
  get "send_multipart_mail", to: "home#send_multipart_mail"
end
