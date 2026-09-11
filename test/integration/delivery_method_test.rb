require "test_helper"
require "launchy"
require "minitest/mock"

module LetterThief
  class DeliveryMethodTest < ActionDispatch::IntegrationTest
    test "creates an EmailMessage when delivering with letter_thief" do
      assert_equal Rails.application.config.action_mailer.delivery_method, :letter_thief
      assert_difference -> { EmailMessage.count }, 1 do
        MyMailer.multipart_mail.deliver_now
      end
    end

    test "opens the sent email in the browser by default" do
      assert LetterThief.open_sent_emails
      opened_urls = []
      Launchy.stub(:open, ->(url) { opened_urls << url }) do
        MyMailer.multipart_mail.deliver_now
      end
      assert_equal [email_message_url(EmailMessage.last)], opened_urls
    end

    test "does not open the sent email when open_sent_emails is false" do
      LetterThief.open_sent_emails = false
      opened_urls = []
      Launchy.stub(:open, ->(url) { opened_urls << url }) do
        assert_difference -> { EmailMessage.count }, 1 do
          MyMailer.multipart_mail.deliver_now
        end
      end
      assert_empty opened_urls
    ensure
      LetterThief.open_sent_emails = true
    end

    private

    def email_message_url(email_message)
      LetterThief::Engine.routes.url_helpers.email_message_url(email_message, Rails.configuration.action_mailer.default_url_options)
    end
  end
end
