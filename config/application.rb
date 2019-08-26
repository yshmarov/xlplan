require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Xlplan
  class Application < Rails::Application
    config.middleware.use Rack::Attack     
    # uncomment to ensure a common layout for devise forms
    #   config.to_prepare do   # Devise
    #     Devise::SessionsController.layout "sign"
    #     Devise::RegistrationsController.layout "sign"
    #     Devise::ConfirmationsController.layout "sign"
    #     Devise::PasswordsController.layout "sign"
    #   end   # Devise
    # Initialize configuration defaults for originally generated Rails version.
    #config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    #config.i18n.fallbacks = [I18n.default_locale]

    # Whitelist locales available for the application
    I18n.available_locales = [:en, :ru, :pl]
    #I18n.enforce_available_locales = false
     
    # Set default locale to something other than :en
    I18n.default_locale = :en
    #I18n.default_locale = Tenant.current_tenant.locale

    config.time_zone = 'UTC'
    #config.action_mailer.default_url_options = { host: 'example.com' }

  end
end
