module LetterThief
  class Interceptor
    def self.delivering_email(mail)
      EmailMessage.create!(
        to: mail.to,
        from: mail.from,
        sender: mail.sender,
        cc: mail.cc,
        bcc: mail.bcc,
        subject: mail.subject,
        body_text: mail.text_part&.decoded || mail.body.decoded,
        body_html: mail.html_part&.decoded,
        headers: mail.header.to_s,
        raw_message: mail.to_s,
        content_type: mail.content_type,
        intercepted_at: Time.current
      )
    rescue => e
      Rails.logger.error("[LetterThief] Failed to store intercepted email: #{e.message}")
    end
  end
end
