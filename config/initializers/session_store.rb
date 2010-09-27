# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_businessprofile_session',
  :secret      => '70074e6fac95fb9d22f6eb8dfca3a1e53818b2912211e7c498a3ce2a9aeeb1d26811afda52ccb4a09956ee1c5ddd4c6f9bf2492bff9d991766cda12b13b3fb67'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
