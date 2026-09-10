module LetterThief
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true

    connects_to(**LetterThief.connects_to) if LetterThief.connects_to
  end
end
