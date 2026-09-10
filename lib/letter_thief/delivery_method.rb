require "digest/sha1"

module LetterThief
  class DeliveryMethod
    def initialize(options = {})
    end

    def deliver!(mail)
      delivered_mail = Observer.delivered_email(mail)
      require "launchy"
      ::Launchy.open(LetterThief::Engine.routes.url_helpers.email_message_url(delivered_mail, Rails.configuration.action_mailer.default_url_options))
    rescue LoadError
      puts "WARNING: LetterThief requires the 'launchy' gem to open the email in a web browser. Add it to your Gemfile."
    end
  end
end
