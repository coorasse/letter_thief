module LetterThief
  class EmailMessagesController < ApplicationController
    layout "letter_thief/application"

    def index
      @emails = EmailMessage.order(intercepted_at: :desc).limit(50)
    end

    def show
      @email = EmailMessage.find(params[:id])
    end
  end
end
