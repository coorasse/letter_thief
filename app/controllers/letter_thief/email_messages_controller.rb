# frozen_string_literal: true

module LetterThief
  class EmailMessagesController < ApplicationController
    layout "letter_thief/application"
    before_action :turn_off_csp_nonce_generation

    content_security_policy do |policy|
      policy.style_src :self, :https, :unsafe_inline
    end

    PAGE_SIZE = 20

    def index
      @search = LetterThief::EmailSearch.new(params).perform
    end

    def show
      @email = EmailMessage.find(params[:id])
    end

    private

    def turn_off_csp_nonce_generation
      request.content_security_policy_nonce_directives = []
    end
  end
end
