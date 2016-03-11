# Each time a record is set we check whether its session has already timed out
# or not, based on last request time. If so and :expire_auth_token_on_timeout
# is set to true, the record's auth token is reset.

# This is a backport of the functionality of expire_auth_token_on_timeout that
# has been removed from devise in version 3.5.2.
#
# For the original version cf.
# https://github.com/plataformatec/devise/blob/v3.5.1/lib/devise/hooks/timeoutable.rb.

Warden::Manager.after_set_user do |record, warden, options|
  scope = options[:scope]
  env   = warden.request.env

  if record && record.respond_to?(:timedout?) && warden.authenticated?(scope) &&
     options[:store] != false && !env['devise.skip_timeoutable']

    last_request_at = warden.session(scope)['last_request_at']

    if last_request_at.is_a? Integer
      last_request_at = Time.at(last_request_at).utc
    elsif last_request_at.is_a? String
      last_request_at = Time.parse(last_request_at)
    end

    if record.timedout?(last_request_at) && !env['devise.skip_timeout']
      if record.respond_to?(:expire_auth_token_on_timeout) && record.expire_auth_token_on_timeout
        record.reset_authentication_token!
      end
    end
  end
end
