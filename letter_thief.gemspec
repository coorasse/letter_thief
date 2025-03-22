require_relative "lib/letter_thief/version"

Gem::Specification.new do |spec|
  spec.name = "letter_thief"
  spec.version = LetterThief::VERSION
  spec.authors = ["Alessandro Rodi"]
  spec.email = ["alessandro.rodi@renuo.ch"]
  spec.homepage = "https://github.com/coorasse/letter_thief"
  spec.summary = "Log emails in Rails and visualize them."
  spec.description = "LetterThief allows you to record sent emails in your database."
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/coorasse/letter_thief"
  spec.metadata["changelog_uri"] = "https://github.com/coorasse/letter_thief/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0"
end
