require "devise/token_authenticatable/version"

module Devise
  module TokenAuthenticatable

  end
end

Devise::add_module(:plain_token_authenticatable, model: 'devise/token_authenticatable/model', strategy: true)
