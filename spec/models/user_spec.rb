require "rails_helper"

RSpec.describe User, type: :model do
  describe '#set_auth_token' do
    context 'when the user does not exist' do
      let(:user) { FactoryBot.build(:user, auth_token: nil) }

      it 'generates a new auth_token' do
        user.save

        expect(user.auth_token).to be_present
      end
    end
  end

  describe '.from_omniauth' do
    let(:access_token) { OpenStruct.new(info: data) }
    let(:data) do
      {
        'name' => 'foo',
        'email'  => 'foo@example.com'
      }
    end

    subject { User.from_omniauth(access_token) }

    before do
      allow(Devise).to receive(:friendly_token).and_return('123456789')
    end

    context 'when the user is already registered' do
      before { FactoryBot.create(:user, name: 'foo bar', email: 'foo@bar.com') }

      it 'returns the registered user' do
        expect(subject).to have_attributes(name: 'foo bar',
          email: 'foo@bar.com'
        )
      end
    end

    context 'when the user is not registered' do
      it 'creates the user' do
        subject

        expect(User.count).to eq 1
      end

      it 'returns the created user' do
        expect(subject).to have_attributes(name: 'foo',
          email: 'foo@example.com',
          password: '123456789'
        )
      end
    end
  end
end
