require "devise/token_authenticatable/strategy"

module Devise
  module TokenAuthenticatable

    # Authentication token params key name of choice. E.g. /users/sign_in?some_key=...
    mattr_accessor :token_authentication_key
    @@token_authentication_key = :auth_token

    # Defines if the authentication token is reset before the model is saved.
    mattr_accessor :should_reset_authentication_token
    @@should_reset_authentication_token = true

    # Defines if the authentication token is set - if not already - before the model is saved.
    mattr_accessor :should_ensure_authentication_token
    @@should_ensure_authentication_token = true

    # Enable the configuration of the TokenAuthenticatable
    # strategy with a block:
    #
    #   Devise::TokenAuthenticatable.setup do |config|
    #     config.token_authentication_key = :other_key
    #   end
    #
    def self.setup
      yield self
    end
  end
end

# Register TokenAuthenticatable module in Devise.
Devise::add_module  :token_authenticatable,
                    model: 'devise/token_authenticatable/model',
                    strategy: true,
                    no_input: true
