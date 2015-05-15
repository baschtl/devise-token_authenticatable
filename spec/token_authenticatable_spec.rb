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

  context "configuring the should_reset_authentication_token" do
    let(:should_reset) { true }

    it "should set the configuration" do
      expect {
        Devise::TokenAuthenticatable.setup do |config|
          config.should_reset_authentication_token = should_reset
        end
      }.to change { Devise::TokenAuthenticatable.should_reset_authentication_token }.from(false).to(should_reset)
    end
  end

  context "configuring the should_ensure_authentication_token" do
    let(:should_ensure) { true }

    it "should set the configuration" do
      expect {
        Devise::TokenAuthenticatable.setup do |config|
          config.should_ensure_authentication_token = should_ensure
        end
      }.to change { Devise::TokenAuthenticatable.should_ensure_authentication_token }.from(false).to(should_ensure)
    end
  end

end
