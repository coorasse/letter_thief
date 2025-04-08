# frozen_string_literal: true

module LetterThief
  class EmailMessagesController < ApplicationController
    layout "letter_thief/application"
    before_action :set_email, only: [:show, :destroy]

    content_security_policy do |policy|
      policy.style_src :self, :https, :unsafe_inline
    end

    PAGE_SIZE = 20

    def index
      @search = LetterThief::EmailSearch.new(params).perform
    end

    def show
    end

    def destroy
      redirect_to email_messages_path if @email.destroy
    end

    private

    def set_email
      @email = EmailMessage.find(params[:id])
    end
  end
end
