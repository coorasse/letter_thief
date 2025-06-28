require "letter_thief/observer"
require "letter_thief/delivery_method"

module LetterThief
  class Engine < ::Rails::Engine
    isolate_namespace LetterThief

    initializer "letter_thief.add_observer" do
      unless Rails.application.config.action_mailer.delivery_method == :letter_thief
        ActiveSupport.on_load(:action_mailer) do
          ActionMailer::Base.register_observer(LetterThief::Observer)
        end
      end
    end

    initializer "letter_thief.add_delivery_method" do
      ActiveSupport.on_load(:action_mailer) do
        ActionMailer::Base.add_delivery_method(:letter_thief, LetterThief::DeliveryMethod)
      end
    end
  end
end
