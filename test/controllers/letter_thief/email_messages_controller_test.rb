# frozen_string_literal: true

require "test_helper"

module LetterThief
  class EmailMessagesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      EmailMessage.delete_all

      @email = EmailMessage.create!(
        from: ["alice@example.com"],
        to: ["bob@example.com"],
        subject: "Important news",
        intercepted_at: Time.utc(2024, 1, 1, 10)
      )

      @email2 = EmailMessage.create!(
        from: ["carol@example.com"],
        to: ["dave@example.com"],
        subject: "Weekly update",
        intercepted_at: Time.utc(2024, 1, 2, 12)
      )
    end

    test "#index" do
      get email_messages_url
      assert_response :success
      assert_select 'table', 1, "Should have a table to display emails"
    end

    test "#show" do
      get email_message_url(@email)
      assert_response :success
    end

    test "#destroy" do
      assert_difference("LetterThief::EmailMessage.count", -1) do
        delete email_message_url(@email)
      end

      assert_redirected_to email_messages_path
    end

    test "#destroy_all" do
      assert_equal 2, EmailMessage.count, "Should have 2 emails before destroy_all"
      
      delete destroy_all_email_messages_url
      
      assert_redirected_to email_messages_path
      assert_equal 0, EmailMessage.count, "Should have no emails after destroy_all"
      assert_equal 'All email messages have been deleted', flash[:notice]
    end
  end
end
