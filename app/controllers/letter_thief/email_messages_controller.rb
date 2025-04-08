# frozen_string_literal: true

module LetterThief
  class EmailMessagesController < ApplicationController
    layout "letter_thief/application"

    content_security_policy do |policy|
      policy.style_src :self, :https, :unsafe_inline
    end
    Rails.application.config.content_security_policy_nonce_directives = []

    PAGE_SIZE = 20

    def index
      @search = LetterThief::EmailSearch.new(params).perform
    end

    def show
      @email = EmailMessage.find(params[:id])
    end
  end
end
