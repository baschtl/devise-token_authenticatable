# Helper methods for user sign in with
# authentication token.
#

# Signs in a user via different methods (i.e., HTTP AUTH,
# Token Auth, plain). If no user is given with the +options+
# a new one is created.
#
def sign_in_as_new_user_with_token(options = {})
  user = options.delete(:user) || create(:user, :with_authentication_token)

  options[:auth_token_key] ||= Devise::TokenAuthenticatable.token_authentication_key
  options[:auth_token]     ||= user.authentication_token

  if options[:http_auth]
    header = "Basic #{Base64.encode64("#{options[:auth_token]}:X")}"
    get users_path(format: :xml), {}, "HTTP_AUTHORIZATION" => header
  elsif options[:token_auth]
    token_options = options[:token_options] || {}
    header = ActionController::HttpAuthentication::Token.encode_credentials(options[:auth_token], token_options)
    get users_path(format: :xml), {}, "HTTP_AUTHORIZATION" => header
  else
    get users_path(options[:auth_token_key].to_sym => options[:auth_token])
  end

  user
end
