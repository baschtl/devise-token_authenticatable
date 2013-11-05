require "devise/token_authenticatable/strategy"

module Devise
  module PlainTokenAuthenticatable

  end
end

# Register PlainTokenAuthenticatable module in Devise.
Devise::add_module  :plain_token_authenticatable,
                    model: 'devise/token_authenticatable/model',
                    strategy: true,
                    no_input: true
