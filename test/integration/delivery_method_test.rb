require "test_helper"
require "minitest/mock"

module LetterThief
  class DeliveryMethodTest < ActionDispatch::IntegrationTest
    test "creates an EmailMessage when delivering with letter_thief" do
      assert_equal Rails.application.config.action_mailer.delivery_method, :letter_thief
      assert_difference -> { EmailMessage.count }, 1 do
        MyMailer.multipart_mail.deliver_now
      end
    end

    test "creates an EmailMessage even when launchy is not installed" do
      delivery_method = DeliveryMethod.new
      require_without_launchy = ->(name) { (name == "launchy") ? raise(LoadError, "cannot load such file -- launchy") : require(name) }

      delivery_method.stub(:require, require_without_launchy) do
        assert_difference -> { EmailMessage.count }, 1 do
          assert_output(/launchy/) do
            delivery_method.deliver!(MyMailer.multipart_mail.message)
          end
        end
      end
    end
  end
end
