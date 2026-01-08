require "test_helper"

class LetterThiefTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert LetterThief::VERSION
  end

  test "observer_enabled is true by default" do
    assert LetterThief.observer_enabled
  end

  test "observer_enabled can be set to false" do
    original_value = LetterThief.observer_enabled
    LetterThief.observer_enabled = false
    assert_equal false, LetterThief.observer_enabled
  ensure
    LetterThief.observer_enabled = original_value
  end
end
