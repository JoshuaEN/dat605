require 'rails_helper'

RSpec.describe User, type: :model do
	it 'is not valid with duplicate session key' do
		key = 'abc123'
		create(:user, session_key: key)
		expect(build(:user, session_key: key).valid?).to eq(false)
	end


	describe 'find_by_session_key' do
		it 'finds user by session key' do
			key = 'abc123'
			user = create(:user, session_key: key)

			expect(User.find_by_session_key(key)).to eq(user)
		end
	end

	describe 'create_from_auth' do
		before :all do
			@auth_provider = 'test'
			@auth_uid = '1'
			@user = User.build_from_auth @auth_provider, @auth_uid
		end
		it 'sets auth provider' do
			expect(@user.auth_provider).to eq('test')
		end
		it 'sets auth uid' do
			expect(@user.auth_uid).to eq('1')
		end
	end
end
