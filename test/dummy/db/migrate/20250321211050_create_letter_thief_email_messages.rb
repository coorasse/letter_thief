class CreateLetterThiefEmailMessages < ActiveRecord::Migration[7.2]
  def change
    adapter = ActiveRecord::Base.connection.adapter_name.downcase

    create_table :letter_thief_email_messages do |t|
      if adapter.include?("postgresql")
        t.string :to, array: true
        t.string :from, array: true
        t.string :sender, array: true
        t.string :cc, array: true
        t.string :bcc, array: true
      else
        t.text :to
        t.text :from
        t.text :sender
        t.text :cc
        t.text :bcc
      end

      t.string :subject
      t.text :body_text
      t.text :body_html
      t.text :headers
      t.text :raw_message
      t.string :content_type
      t.datetime :intercepted_at

      t.timestamps
    end
  end
end
