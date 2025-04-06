require "letter_thief/version"
require "letter_thief/engine"

module LetterThief
  mattr_accessor :connects_to

  def self.used_activestorage_space
    ActiveStorage::Blob
      .joins(:attachments)
      .where(active_storage_attachments: {
        record_type: "LetterThief::EmailMessage"
      }).sum(:byte_size)
  end
end
