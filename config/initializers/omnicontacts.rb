require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "client_id", "client_secret", {:redirect_path => "/oauth2callback", :ssl_ca_file => "/etc/ssl/certs/curl-ca-bundle.crt"}
  importer :facebook, "client_id", "client_secret"
end