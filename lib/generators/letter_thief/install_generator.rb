require "rails/generators"
require "rails/generators/active_record"

module LetterThief
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def copy_migration
        migration_template "create_email_messages.rb.erb",
          "db/migrate/create_letter_thief_email_messages.rb",
          migration_version: migration_version
      end

      private

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end
  end
end
