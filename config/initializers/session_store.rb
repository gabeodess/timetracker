# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_timetracker_session',
  :secret      => '936494f10e0bc636db3622fea25af9b314b0fd33a5e7cca3f1b0f103a69889fcd89433eecc4df460744de37c3a55ee9f652a855ca2d674b522e662ffa57c3e64'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
