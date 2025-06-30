require "test_helper"

module LetterThief
  class DeliveryMethodTest < ActionDispatch::IntegrationTest
    test "creates an EmailMessage when delivering with letter_thief" do
      assert_equal Rails.application.config.action_mailer.delivery_method, :letter_thief
      assert_difference -> { EmailMessage.count }, 1 do
        MyMailer.multipart_mail.deliver_now
      end
    end
  end
end
