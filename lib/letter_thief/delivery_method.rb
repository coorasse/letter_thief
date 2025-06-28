require "digest/sha1"

module LetterThief
  class DeliveryMethod
    def initialize(options = {})
    end

    def deliver!(mail)
      require "launchy"
      email = Observer.delivered_email(mail)
      ::Launchy.open(LetterThief::Engine.routes.url_helpers.email_message_url(email, Rails.configuration.action_mailer.default_url_options))
    rescue LoadError
      puts "WARNING: LetterThief requires the 'launchy' gem to open the email in a web browser. Add it to your Gemfile."
    end
  end
end
