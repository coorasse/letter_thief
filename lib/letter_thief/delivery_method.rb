require "digest/sha1"

module LetterThief
  class DeliveryMethod
    def initialize(options = {})
    end

    def deliver!(mail)
      open_sent_emails = ENV.fetch("LETTER_THIEF_OPEN_SENT_EMAILS", "true")
      # this is not really true, we don't know if it's the last email, but for the moment this should do.
      self.class.open_latest_email if ActiveRecord::Type::Boolean.new.cast(open_sent_emails)
    end

    def self.open_latest_email
      require "launchy"
      ::Launchy.open(LetterThief::Engine.routes.url_helpers.email_message_url(LetterThief::EmailMessage.last, Rails.configuration.action_mailer.default_url_options))
    rescue LoadError
      puts "WARNING: LetterThief requires the 'launchy' gem to open the email in a web browser. Add it to your Gemfile."
    end
  end
end
