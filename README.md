# LetterThief

<img alt="logo.webp" src="logo.webp" width="100px"/>

A Rails engine to log email deliveries.

This gem allows you to log on the database the emails sent by your application.

But that's not all! It provides also an interface to visualize them directly in the Browser.

You can of course navigate and search your emails using ActiveRecord `LetterThief::EmailMessage` model.

And that's not all! You can use letter thief as a delivery method in your application as well.

Set `config.action_mailer.delivery_method = :letter_thief` to stop sending emails and have them only logged in your
database. That's particularly useful in development environments or staging/pre-production environments as well.
Amazing, right? And that's not all! 😱

If you used `letter_opener` in the past you know how cool it is to have
the sent emails opened automatically in your Browser when working locally.
LetterThief supports this as well with the very same mechanism, but `launchy` is not a direct dependency.
This means that you'll have to add it yourself to the Gemfile.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "letter_thief"
```

And then execute:

```bash
bundle install
bin/rails generate letter_thief:install
bin/rails db:migrate
```

This will create the necessary tables.

If you want to stop sending emails, you can use it also as delivery method:

```ruby
config.action_mailer.delivery_method = :letter_thief
config.action_mailer.raise_delivery_errors = true
```

If you want emails to be opened immediately, add `launchy` to your Gemfile.

```ruby
group :development do
  gem "launchy"
end
```

and LetterThief will open emails directly in your Browser a la Letter Opener.

### Separate database

If you'd like to store your emails on a separate database, you can configure it via:

`config.letter_thief.connects_to = {database: {writing: :letter_thief}}` and of course you'll need a separate database
configuration. Here is an example:

```yml
development:
  primary:
    <<: *default
    database: my_app_development
  letter_thief:
    <<: *default
    database: my_app_letter_thief_development
    migrations_paths: db/letter_thief_migrate
```

## Varia

> [!NOTE]
> Persisting the emails on the database might have privacy related concerns. You might want to encrypt stuff.  

> [!NOTE]
> You might want to schedule a cleanup job to remove old records from time to time.

> [!NOTE]
> For this gem I was heavily inspired by letter_opener, which I used for over ten years. ❤️

## Development

You can run the tests with `bin/test`. By default they run on sqlite. To run them on postgres or mysql, specify the
TARGET_DB.

```bash
bin/test #sqlite
TARGET_DB=postgres bin/test #postgres
TARGET_DB=mysql bin/test #mysql
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/coorasse/letter_thief.
This project is intended to be a safe, welcoming space for collaboration.

Try to be a decent human being while interacting with other people.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

