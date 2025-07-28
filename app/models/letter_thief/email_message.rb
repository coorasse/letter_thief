module LetterThief
  class EmailMessage < ApplicationRecord
    self.table_name = "letter_thief_email_messages"

    connects_to(**LetterThief.connects_to) if LetterThief.connects_to

    puts "is activestorage available? #{LetterThief.activestorage_available?}"
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
  end
end
