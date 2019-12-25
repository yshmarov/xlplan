require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  #importer :gmail, "client_id", "client_secret", {:redirect_path => "/oauth2callback", :ssl_ca_file => "/etc/ssl/certs/curl-ca-bundle.crt"}
  importer :gmail, "727048089494-u05glngdrhh01hptdsbkvh7ad785b35b.apps.googleusercontent.com", "ermd-bLjrffy6Pwscw5K82hK", {:redirect_path => "/contacts/gmail/contact_callback", :max_results => 1500}
end