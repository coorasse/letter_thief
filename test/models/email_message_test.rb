require "test_helper"

module LetterThief
  class EmailMessageTest < ActiveSupport::TestCase
    test "stores emails on the configured database" do
      expected_database = (ENV["LETTER_THIEF_SEPARATE_DB"] == "true") ? "letter_thief" : "primary"

      assert_equal expected_database, EmailMessage.connection_db_config.name
      assert_equal expected_database, ApplicationRecord.connection_db_config.name
    end

    test "keeps ActiveStorage on the primary database" do
      skip "ActiveStorage is disabled" unless LetterThief.activestorage_available?

      assert_equal "primary", ActiveStorage::Blob.connection_db_config.name
    end
  end
end
