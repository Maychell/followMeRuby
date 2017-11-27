require 'rails_helper'

RSpec.describe Api::V1::SignInController, type: :controller do
  describe 'POST' do
    context 'when there is a valid token' do
      let(:response_body) { JSON.parse(response.body) }
      let(:payload) do
        {
          'name' => 'foo',
          'email' => 'foo@bar.com',
          'image_url' => 'foo_bar'
        }
      end

      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .and_return(payload)
      end

      context 'when the user does not exist' do
        it 'creates the user' do
          post :create

          expect(User.count).to eq 1
        end

        it 'returns the created user' do
          post :create

          expect(response_body['name']).to eq 'foo'
          expect(response_body['email']).to eq 'foo@bar.com'
        end
      end

      context 'when the user already exists' do
        before { FactoryBot.create(:user, name: 'foo', email: 'foo@bar.com') }

        it 'does not create a new one' do
          post :create

          expect(User.count).to eq 1
        end

        it 'returns the user' do
          post :create

          expect(response_body['name']).to eq 'foo'
          expect(response_body['email']).to eq 'foo@bar.com'
        end
      end
    end

    context 'when there is a invalid token' do
      let(:response_body) { JSON.parse(response.body) }

      before do
        allow_any_instance_of(GoogleIDToken::Validator).to receive(:check)
          .and_raise(GoogleIDToken::ValidationError)
      end

      it 'does not create the user' do
        post :create

        expect(User.count).to be_zero
      end

      it 'returns an error message' do
        post :create

        expect(response_body['error']).to eq 'Login com Google não autorizado'
      end
    end
  end
end
