# Configure LetterThief to use a custom base controller for authentication
# Uncomment the line below to test the base_controller_class configuration:
# LetterThief.base_controller_class = "AdminController"

LetterThief.connects_to = {database: {writing: :letter_thief}} if ENV["LETTER_THIEF_SEPARATE_DB"] == "true"
