require 'spec_helper'

describe Devise::Strategies::PlainTokenAuthenticatable do

  context "with valid authentication token key and value" do

    context "through params" do

      it "should redirect to root path" do
        swap Devise, :token_authentication_key => :secret_token do
          sign_in_as_new_user_with_token

          response.should redirect_to(root_path)
        end
      end

      it "should authenticate user" do
        swap Devise, :token_authentication_key => :secret_token do
          sign_in_as_new_user_with_token

          expect(warden).to be_authenticated(:user)
        end
      end

      context "when params with the same key as scope exist" do
        let(:user) { create(:user, :with_authentication_token) }

        it 'should redirect to root path' do
          swap Devise, :token_authentication_key => :secret_token do
            get new_user_session_path(locale: 'en', Devise.token_authentication_key => user.authentication_token, user: { some: "data" })

            response.should redirect_to(root_path)
          end
        end

        it 'should authenticate user' do
          swap Devise, :token_authentication_key => :secret_token do
            get new_user_session_path locale: 'en', Devise.token_authentication_key => user.authentication_token, user: { some: "data" }

            expect(warden).to be_authenticated(:user)
          end
        end
      end

      context "when request is stateless" do

        it 'should not store the session' do
          swap Devise, :token_authentication_key => :secret_token, :skip_session_storage => [:token_auth] do
            sign_in_as_new_user_with_token
            expect(warden).to be_authenticated(:user)

            # Try to access a resource that requires authentication
            get users_path
            response.should redirect_to(new_user_session_path)
            expect(warden).to_not be_authenticated(:user)
          end
        end
      end

      context "when request is stateless and timeoutable" do

        it 'should authenticate user' do
          swap Devise, :token_authentication_key => :secret_token, :skip_session_storage => [:token_auth], timeout_in: (0.1).second do
            user = sign_in_as_new_user_with_token
            expect(warden).to be_authenticated(:user)

            # Expiring does not work because we are setting the session value when accessing the resource
            Timecop.travel(Time.now + (0.3).second)

            sign_in_as_new_user_with_token(user: user)
            expect(warden).to be_authenticated(:user)

            Timecop.return
          end
        end
      end

      context "when expire_auth_token_on_timeout is set to true, timeoutable is enabled and we have a timed out session" do

        it 'should reset authentication token and not authenticate' do
          #pending "The user model is not timeoutable."
          swap Devise, :token_authentication_key => :secret_token, expire_auth_token_on_timeout: true, timeout_in: (-1).minute do
            user = sign_in_as_new_user_with_token
            expect(warden).to be_authenticated(:user)
            token = user.authentication_token

            sign_in_as_new_user_with_token(user: user)
            expect(warden).to_not be_authenticated(:user)
            user.reload
            expect(token).to_not eq(user.authentication_token)
          end
        end
      end

      context "when not configured" do

        it "should be a success" do
          swap Devise, :token_authentication_key => :secret_token, :params_authenticatable => [:database] do
            sign_in_as_new_user_with_token

            response.should be_success
          end
        end

        it "should show the sign in page" do
          swap Devise, :token_authentication_key => :secret_token, :params_authenticatable => [:database] do
            sign_in_as_new_user_with_token

            expect(@request.path).to eq(new_user_session_path)
          end
        end

        it "should not authenticate user" do
          swap Devise, :token_authentication_key => :secret_token, :params_authenticatable => [:database] do
            sign_in_as_new_user_with_token

            expect(warden).to_not be_authenticated(:user)
          end
        end
      end
    end

    context "through http" do

      it "should redirect to root path" do
        swap Devise, :token_authentication_key => :secret_token, http_authenticatable: true do
          sign_in_as_new_user_with_token(http_auth: true)

          response.should redirect_to(root_path)
        end
      end

      it "should authenticate user" do
        swap Devise, :token_authentication_key => :secret_token, http_authenticatable: true do
          sign_in_as_new_user_with_token(http_auth: true)

          expect(warden).to be_authenticated(:user)
        end
      end

      context "when not configured" do

        it "should be a success" do
          swap Devise, :token_authentication_key => :secret_token, :http_authenticatable => [:database] do
            sign_in_as_new_user_with_token(http_auth: true)

            response.should be_success
          end
        end

        it "should show the sign in page" do
          swap Devise, :token_authentication_key => :secret_token, :http_authenticatable => [:database] do
            sign_in_as_new_user_with_token(http_auth: true)

            expect(@request.path).to eq(new_user_session_path)
          end
        end

        it "should not authenticate user" do
          swap Devise, :token_authentication_key => :secret_token, :http_authenticatable => [:database] do
            sign_in_as_new_user_with_token(http_auth: true)

            expect(warden).to_not be_authenticated(:user)
          end
        end
      end
    end

    context "through http header" do

      it "should redirect to root path" do
        swap Devise, :token_authentication_key => :secret_token, http_authenticatable: true do
          sign_in_as_new_user_with_token(token_auth: true)

          response.should redirect_to(root_path)
        end
      end

      it "should authenticate user" do
        swap Devise, :token_authentication_key => :secret_token, http_authenticatable: true do
          sign_in_as_new_user_with_token(token_auth: true)

          expect(request.env['devise.token_options']).to eq({})
          expect(warden).to be_authenticated(:user)
        end
      end

      context "with options" do
        let(:signature) { "**TESTSIGNATURE**" }

        it "should redirect to root path" do
          swap Devise, :token_authentication_key => :secret_token, :http_authenticatable => [:token_options] do
            sign_in_as_new_user_with_token(token_auth: true, token_options: { signature: signature, nonce: 'def' })

            response.should redirect_to(root_path)
          end
        end

        it "should set the signature option" do
          swap Devise, :token_authentication_key => :secret_token, :http_authenticatable => [:token_options] do
            sign_in_as_new_user_with_token(token_auth: true, token_options: { signature: signature, nonce: 'def' })

            expect(request.env['devise.token_options'][:signature]).to eq(signature)
          end
        end

        it "should set the nonce option" do
          swap Devise, :token_authentication_key => :secret_token, :http_authenticatable => [:token_options] do
            sign_in_as_new_user_with_token(token_auth: true, token_options: { signature: signature, nonce: 'def' })

            expect(request.env['devise.token_options'][:nonce]).to eq('def')
          end
        end

        it "should authenticate user" do
          swap Devise, :token_authentication_key => :secret_token, :http_authenticatable => [:token_options] do
            sign_in_as_new_user_with_token(token_auth: true, token_options: { signature: signature, nonce: 'def' })

            expect(warden).to be_authenticated(:user)
          end
        end
      end

      context "with denied token authorization" do

        it "should be a success" do
          swap Devise, :token_authentication_key => :secret_token, http_authenticatable: false do
            sign_in_as_new_user_with_token(token_auth: true)

            response.should be_success
          end
        end

        it "should show the sign in page" do
          swap Devise, :token_authentication_key => :secret_token, http_authenticatable: false do
            sign_in_as_new_user_with_token(token_auth: true)

            expect(@request.path).to eq(new_user_session_path)
          end
        end

        it "should not authenticate user" do
          swap Devise, :token_authentication_key => :secret_token, http_authenticatable: false do
            sign_in_as_new_user_with_token(token_auth: true)

            expect(warden).to_not be_authenticated(:user)
          end
        end
      end
    end
  end

  context "with improper authentication token key" do

    it "should show the sign in page" do
      swap Devise, :token_authentication_key => :donald_duck_token do
        sign_in_as_new_user_with_token(:auth_token_key => :secret_token)

        expect(@request.path).to eq(new_user_session_path)
      end
    end

    it "should not authenticate user" do
      swap Devise, :token_authentication_key => :donald_duck_token do
        sign_in_as_new_user_with_token(:auth_token_key => :secret_token)

        expect(warden).to_not be_authenticated(:user)
      end
    end

    it "should not be subject to injection" do
      swap Devise, :token_authentication_key => :secret_token do
        user1 = create(:user, :with_authentication_token)

        # Clean up user cache
        @user = nil

        user2 = create(:user, :with_authentication_token)

        expect(user1).to_not eq(user2)
        get users_path(Devise.token_authentication_key.to_s + '[$ne]' => user1.authentication_token)
        expect(warden).to_not be_authenticated(:user)
      end
    end
  end

  context "with improper authentication token value" do

    context "through params" do

      before do
        sign_in_as_new_user_with_token(auth_token: '*** INVALID TOKEN ***')
      end

      it "should show sign in page" do
        expect(@request.path).to eq(new_user_session_path)
      end

      it "should not authenticate user" do
        expect(warden).to_not be_authenticated(:user)
      end
    end

    context "through http header" do

      before do
        sign_in_as_new_user_with_token(token_auth: true, auth_token: '*** INVALID TOKEN ***')
      end

      it "should be a success" do
        response.should be_success
      end

      it "does not authenticate with improper authentication token value in header" do
        expect(warden).to_not be_authenticated(:user)
      end
    end
  end
end
