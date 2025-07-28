# TODO

* Add support for separate database.
* Add basic tasks for cleaning up.
* Run tests on different ruby/rails/database combinations.

# 0.3.1

* Fix email_messages#show page when ActiveStorage is not available. 

# 0.3.0

* Switch from interceptors to observers.
* Support apps without ActiveStorage (no attachments persisted).
* Add button to delete all messages.

# 0.2.0

* Breaking change: dropped raw_message in favour of a separate attachment. Remove the column if you are migrating from a
  previous version with `remove_column :letter_thief_email_messages, :raw_message`.
* Show space used by each logged email and total space used.
* Relax CSP rules for the LetterThief pages to allow inline CSS styles.

# 0.1.1

* Added a root_path for the engine.

# 0.1.0

* Added an interceptor and database table.
* Added views to visualize emails and search them.
* Added delivery method to open with Launchy.

