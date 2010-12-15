# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_backchannel_session',
  :secret      => '833cfe2139574b6b8e1d2c0659467b329f8aeb6081db35503eb85e1740d5593b1fecf49f98c4617aeb7136d262a738eec3e4cb1e25a1007d55fb95ede3968d0e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
