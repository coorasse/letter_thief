module LetterThief
  module ApplicationHelper
    def parsed_body_html(email)
      rendered = email.body_html
      if LetterThief.activestorage_available?
        email.attachments.each do |attachment|
          rendered.gsub!("cid:#{attachment.blob.metadata["cid"]}", main_app.rails_blob_path(attachment))
        end
      end
      # autolinking can be implemented for text bodies
      # rendered.gsub!(URI::Parser.new.make_regexp(%W[https http])) do |link|
      #   "<a href=\"#{ link }\">#{ link }</a>"
      # end
      rendered
    end
  end
end
