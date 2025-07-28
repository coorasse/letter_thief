module LetterThief
  class EmailMessage < ApplicationRecord
    self.table_name = "letter_thief_email_messages"

    connects_to(**LetterThief.connects_to) if LetterThief.connects_to

    puts "is activestorage available? #{ActiveRecord::Base.connection.table_exists?("active_storage_attachments")}"

    puts "Adapter: #{ActiveRecord::Base.connection.adapter_name}"
    puts "Database: #{ActiveRecord::Base.connection.current_database rescue 'N/A'}"
    puts "Config: #{ActiveRecord::Base.connection_db_config.inspect}"
    puts "Tables: #{ActiveRecord::Base.connection.tables.inspect}"
    cfg = ActiveRecord::Base.connection_db_config.configuration_hash
    puts "Adapter:  #{cfg[:adapter]}"
    puts "Database: #{cfg[:database]}"
    puts "Pool:     #{cfg[:pool]}"
    puts "Timeout:  #{cfg[:timeout]}"
    if ActiveRecord::Base.connection.table_exists?("active_storage_attachments")
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
