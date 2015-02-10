require 'spec_helper'

describe Devise::TokenAuthenticatable do

  context "configuring the token_authentication_key" do
    let(:new_key) { :other_key }

    it "should set the configuration" do
      expect {
        Devise::TokenAuthenticatable.setup do |config|
          config.token_authentication_key = new_key
        end
      }.to change { Devise::TokenAuthenticatable.token_authentication_key }.from(:auth_token).to(new_key)
    end

  end

end
