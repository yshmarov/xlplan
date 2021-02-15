require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  # importer :gmail, "client_id", "client_secret", {:redirect_path => "/oauth2callback", :ssl_ca_file => "/etc/ssl/certs/curl-ca-bundle.crt"}
  # the below credentials are no longer valid ;)
  importer :gmail, "XXXXXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXX", {redirect_path: "/contacts/gmail/contact_callback", max_results: 1500}
end
