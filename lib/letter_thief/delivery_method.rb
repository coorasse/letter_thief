require "digest/sha1"

module LetterThief
  class DeliveryMethod
    def initialize(options = {})
    end

    # this is not really true, we don't know if it's the last email, but for the moment this should do.
    def deliver!(mail)
      require "launchy"

      email = EmailMessage.parse(mail)
      if email.save! && LetterThief.activestorage_available?
        Array(mail.attachments).each { |attachment| email.save_attachment(attachment) }
        email.save_raw(StringIO.new(mail.to_s))
      end

      ::Launchy.open(LetterThief::Engine.routes.url_helpers.email_message_url(email, Rails.configuration.action_mailer.default_url_options))
    rescue LoadError
      puts "WARNING: LetterThief requires the 'launchy' gem to open the email in a web browser. Add it to your Gemfile."
    end
  end
end
