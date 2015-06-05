# Devise::TokenAuthenticatable

[![Tag](https://img.shields.io/github/tag/baschtl/devise-token_authenticatable.svg?style=flat-square)](https://github.com/baschtl/devise-token_authenticatable/releases) [![Build Status](https://img.shields.io/travis/baschtl/devise-token_authenticatable.svg?style=flat-square)](https://travis-ci.org/baschtl/devise-token_authenticatable) [![Code Climate](https://img.shields.io/codeclimate/github/baschtl/devise-token_authenticatable.svg?style=flat-square)](https://codeclimate.com/github/baschtl/devise-token_authenticatable)

This gem provides the extracted Token Authenticatable module of devise. It includes the functionality that was also in [version 3.1.2](https://github.com/plataformatec/devise/tree/v3.1.2) of devise. With the inclusion of this module a user is able to sign in via an authentication token. This token can be given via a query string or HTTP Basic Authentication. See the hint below to understand which version of this gem supports which version of devise.

Use this gem as a starting point for your own token authentication mechanism for devise. Furthermore, if you need token authentication in connection with newer devise releases this gem might be an appropriate solution, too.

## Installation

Add this line to your application's Gemfile:

    gem 'devise-token_authenticatable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise-token_authenticatable

### Which version to use for which version of devise?

*devise-token_authenticatable*  | *devise*
-------------------------------:|---------
`~> 0.1`                        | `~> 3.2.0`
`~> 0.2`                        | `~> 3.3.0`
`~> 0.3`                        | `~> 3.4.0`
`~> 0.4`                        | `~> 3.5.0`

## Usage

Add `:token_authenticatable` to your devise model:

    class User < ActiveRecord::Base
      devise :database_authenticatable, :token_authenticatable
    end

## Configuration

This gem can be configured as shown in the following:

    Devise::TokenAuthenticatable.setup do |config|
      # set the authentication key name used by this module,
      # defaults to :auth_token
      config.token_authentication_key = :other_key_name

      # enable reset of the authentication token before the model is saved,
      # defaults to false
      config.should_reset_authentication_token = true

      # enables the setting of the authentication token - if not already - before the model is saved,
      # defaults to false
      config.should_ensure_authentication_token = true
    end

## Documentation

For your convenience there is also a [source code documentation](http://rubydoc.info/github/baschtl/devise-token_authenticatable/master/frames).

## Contributing

1. Fork it.
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create new Pull Request.
6. Get a thank you!
