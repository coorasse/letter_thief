module LetterThief
  class EmailMessage < ApplicationRecord
    self.table_name = "letter_thief_email_messages"

    connects_to(**LetterThief.connects_to) if LetterThief.connects_to

    if LetterThief.activestorage_available?
      has_many_attached :attachments
      has_one_attached :raw_email
    end

    unless ActiveRecord::Base.connection.adapter_name.downcase.include?("postgresql")
      serialize :to, coder: JSON, type: Array
      serialize :from, coder: JSON, type: Array
      serialize :sender, coder: JSON, type: Array
      serialize :cc, coder: JSON, type: Array
      serialize :bcc, coder: JSON, type: Array
    end

    def type
      /html/.match?(content_type) ? "rich" : "plain"
    end

    def rich?
      type == "rich"
    end

    def multipart?
      body_text.present? && body_html.present?
    end

    def save_attachment(attachment)
      ar_attachment = attachments.attach(
        io: StringIO.new(attachment.body.decoded),
        filename: attachment.filename,
        content_type: attachment.mime_type
      ).last
      ar_attachment.blob.metadata["cid"] = attachment.cid
      ar_attachment.blob.save!
    end

    def save_raw(raw)
      raw_email.attach(
        io: raw,
        filename: "message-#{id}.eml",
        content_type: "message/rfc822"
      )
    end

    def self.parse(mail)
      EmailMessage.new(
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
    end
  end
end
