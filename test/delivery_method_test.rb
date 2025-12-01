require "test_helper"

module LetterThief
  class DeliveryMethodTest < ActiveSupport::TestCase
    def setup
      @old_env = ENV["LETTER_THIEF_OPEN_SENT_EMAILS"]
    end

    def teardown
      if @old_env.nil?
        ENV.delete("LETTER_THIEF_OPEN_SENT_EMAILS")
      else
        ENV["LETTER_THIEF_OPEN_SENT_EMAILS"] = @old_env
      end
    end

    def with_stubbed_class_method(klass, method_name)
      called = false
      original = klass.method(method_name) rescue nil
      klass.define_singleton_method(method_name) { called = true }
      begin
        yield -> { called }
      ensure
        if original
          klass.define_singleton_method(method_name) { |*args| original.call(*args) }
        else
          klass.singleton_class.send(:remove_method, method_name) if klass.singleton_methods.include?(method_name)
        end
      end
    end

    test "tries to open the mail if not configured" do
      ENV.delete("LETTER_THIEF_OPEN_SENT_EMAILS")
      with_stubbed_class_method(LetterThief::DeliveryMethod, :open_latest_email) do |called|
        LetterThief::DeliveryMethod.new.deliver!(:unused_email_argument)
        assert called.call, "expected open_latest_email to be called"
      end
    end

    test "tries to open the mail if explicitly allowed" do
      ENV["LETTER_THIEF_OPEN_SENT_EMAILS"] = "true"
      with_stubbed_class_method(LetterThief::DeliveryMethod, :open_latest_email) do |called|
        LetterThief::DeliveryMethod.new.deliver!(:unused_email_argument)
        assert called.call, "expected open_latest_email to be called"
      end
    end

    test "does not open the email if forbidden" do
      ENV["LETTER_THIEF_OPEN_SENT_EMAILS"] = "false"
      with_stubbed_class_method(LetterThief::DeliveryMethod, :open_latest_email) do |called|
        LetterThief::DeliveryMethod.new.deliver!(:unused_email_argument)
        assert_not called.call, "expected open_latest_email not to be called"
      end
    end
  end
end
