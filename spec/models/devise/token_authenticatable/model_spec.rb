require 'spec_helper'

##
# If a model that is token authenticatable should be tested with
# this shared example the corresponding factory has to provide a trait
# +:with_authentication_token+ that sets the attribute +authentication_token+.
#
# See spec/factories/user.rb for an example.
#
shared_examples "token authenticatable" do

  context "instance methods" do

    describe "#reset_authentication_token" do
      let(:entity) { create(described_class.name.underscore.to_sym, :with_authentication_token) }

      it "should reset authentication token" do
        expect { entity.reset_authentication_token }.to change { entity.authentication_token }
      end
    end

    describe "#ensure_authentication_token" do

      context "with existing authentication token" do
        let(:entity) { create(described_class.name.underscore.to_sym, :with_authentication_token) }

        it "should not change the authentication token" do
          expect { entity.ensure_authentication_token }.to_not change { entity.authentication_token }
        end
      end

      context "without existing authentication token" do
        let(:entity) { create(described_class.name.underscore.to_sym) }

        it "should create an authentication token" do
          entity.authentication_token = nil
          expect { entity.ensure_authentication_token }.to change { entity.authentication_token }
        end
      end
    end

  end

  context "class methods" do

    describe "#find_for_authentication_token" do
      let(:entity) { create(described_class.name.underscore.to_sym, :with_authentication_token) }

      it "should authenticate a valid entity with authentication token and return it" do
        authenticated_entity = described_class.find_for_token_authentication(auth_token: entity.authentication_token)
        expect(entity.authentication_token).to eq(authenticated_entity.authentication_token)
      end

      it "should authenticate with all the options passed in, not just the auth_token" do
        conditions = {facebook_token: entity.facebook_token, auth_token: entity.authentication_token}
        expected_conditions = {facebook_token: entity.facebook_token, authentication_token: entity.authentication_token}

        expect(described_class).to receive(:find_for_authentication).with(expected_conditions).and_call_original

        described_class.find_for_token_authentication(conditions)
      end

      it "should return nil when authenticating an invalid entity by authentication token" do
        authenticated_entity = described_class.find_for_token_authentication(auth_token: entity.authentication_token.reverse)
        expect(authenticated_entity).to be_nil
      end

      it "should not be subject to injection" do
        entity2 = create(described_class.name.underscore.to_sym, :with_authentication_token)

        authenticated_entity = described_class.find_for_token_authentication(auth_token: { '$ne' => entity.authentication_token })
        expect(authenticated_entity).to be_nil
      end
    end

    describe "#required_fields" do

      it "should contain the fields that Devise uses" do
        expect(Devise::Models::TokenAuthenticatable.required_fields(described_class)).to eq([
          :authentication_token
        ])
      end

    end

  end

  context "before_save" do

    let(:entity) { create(described_class.name.underscore.to_sym, :with_authentication_token) }

    context "when the authentication token should be reset" do

      before :each do
        Devise::TokenAuthenticatable.setup do |config|
          config.should_reset_authentication_token = true
        end
      end

      after :each do
        Devise::TokenAuthenticatable.setup do |config|
          config.should_reset_authentication_token = false
        end
      end

      it "resets the authentication token" do
        expect(entity).to receive(:reset_authentication_token).once

        entity.update_attributes(created_at: Time.now)
      end

    end

    context "when the authentication token should not be reset" do

      it "does not reset the authentication token" do
        expect(entity).to_not receive(:reset_authentication_token)

        entity.update_attributes(created_at: Time.now)
      end

    end

    context "when the authentication token should be ensured" do

      before :each do
        Devise::TokenAuthenticatable.setup do |config|
          config.should_ensure_authentication_token = true
        end
      end

      after :each do
        Devise::TokenAuthenticatable.setup do |config|
          config.should_ensure_authentication_token = false
        end
      end

      it "sets the authentication token" do
        expect(entity).to receive(:ensure_authentication_token).once

        entity.update_attributes(created_at: Time.now)
      end

    end

    context "when the authentication token should not be ensured" do

      it "does not set the authentication token" do
        expect(entity).to_not receive(:ensure_authentication_token)

        entity.update_attributes(created_at: Time.now)
      end

    end

  end

end

describe User do
  it_behaves_like "token authenticatable"
end
