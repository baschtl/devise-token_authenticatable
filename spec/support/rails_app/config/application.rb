require File.expand_path('../boot', __FILE__)

module Devise
  module TokenAuthenticatable
    class RailsApp < Rails::Application
      config.active_support.deprecation         = :log
      config.action_mailer.default_url_options  = { host: "localhost", port: 3000 }
      config.action_mailer.delivery_method      = :test
      config.i18n.enforce_available_locales     = false
      config.eager_load                         = false
    end
  end
end
