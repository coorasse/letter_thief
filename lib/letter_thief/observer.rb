module LetterThief
  class Observer
    def self.delivered_email(mail)
      string_io = StringIO.new(mail.to_s)
      email = EmailMessage.create!(
        to: mail.to,
        from: mail.from,
        sender: mail.sender,
        cc: mail.cc,
        bcc: mail.bcc,
        subject: mail.subject,
        body_text: mail.text_part&.decoded || mail.body.decoded,
        body_html: mail.html_part&.decoded,
        headers: mail.header.to_s,
        content_type: mail.content_type,
        intercepted_at: Time.current
      )

      if LetterThief.activestorage_available?
        Array(mail.attachments).each do |attachment|
          ar_attachment = email.attachments.attach(
            io: StringIO.new(attachment.body.decoded),
            filename: attachment.filename,
            content_type: attachment.mime_type
          ).last
          ar_attachment.blob.metadata["cid"] = attachment.cid
          ar_attachment.blob.save!
        end

        email.raw_email.attach(
          io: string_io,
          filename: "message-#{email.id}.eml",
          content_type: "message/rfc822"
        )
      end
    rescue => e
      Rails.logger.error("[LetterThief] Failed to store observed email: #{e.message}")
    end
  end
end
