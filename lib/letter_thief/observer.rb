module LetterThief
  class Observer
    def self.delivered_email(mail)
      email = EmailMessage.parse(mail)
      if email.save! && LetterThief.activestorage_available?
        Array(mail.attachments).each { |attachment| email.save_attachment(attachment) }
        email.save_raw(StringIO.new(mail.to_s))
      end
    rescue => e
      Rails.logger.error("[LetterThief] Failed to store observed email: #{e.message}")
    end
  end
end
