# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_services_session',
  :secret      => '47076da2114cb7a023c452cc0831a14910ccb9c232817d7ebfc564214e36cd5fa7901fcb5cabc094a464d9caeae0c943f3b188e854bf5f00eb7bfffa51a8e98f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
