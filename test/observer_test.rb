require "test_helper"

module LetterThief
  class ObserverTest < ActiveSupport::TestCase
    test "creates an EmailMessage from a basic email" do
      mail = Mail.new do
        from "sender@example.com"
        to "receiver@example.com"
        subject "Hello"
        body "This is a plain text message"
      end

      assert_difference -> { EmailMessage.count }, 1 do
        Observer.delivered_email(mail)
      end

      email = EmailMessage.last
      assert_equal ["receiver@example.com"], email.to
      assert_equal ["sender@example.com"], email.from
      assert_equal "Hello", email.subject
      assert_equal "This is a plain text message", email.body_text
      assert_nil email.body_html
      assert_equal mail.content_type, email.content_type
      refute mail.multipart?
      assert email.intercepted_at.present?
    end

    test "captures both plain text and HTML versions" do
      mail = Mail.new do
        from "alice@example.com"
        to "bob@example.com"
        subject "Multipart"

        text_part do
          body "Plain version"
        end

        html_part do
          content_type "text/html; charset=UTF-8"
          body "<h1>HTML version</h1>"
        end
      end

      Observer.delivered_email(mail)
      email = EmailMessage.last

      assert_equal "Plain version", email.body_text
      assert_equal "<h1>HTML version</h1>", email.body_html
      assert mail.multipart?
    end

    unless ENV['DISABLE_ACTIVESTORAGE'] == "true"
      test "captures also the raw email as attachment" do
        mail = Mail.new do
          from "sender@example.com"
          to "receiver@example.com"
          subject "Hello"
          body "This is a plain text message"
          add_file(filename: "test.txt", content: "This is a test file")
        end

        Observer.delivered_email(mail)

        email = EmailMessage.last
        assert_equal email.attachments.length, 1
        assert email.raw_email.present?
      end
    end
  end
end
