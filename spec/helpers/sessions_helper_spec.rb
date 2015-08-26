require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
	
	describe 'current_user' do
		it 'returns nil if user is not signed in' do
			expect(helper.current_user).to eq(nil)
		end
		
		it 'returns correct user if user is signed in' do
			session_key = 'abc123'
			user = create :user, session_key: session_key
			cookies[:session_key] = session_key

			expect(helper.current_user).to eq(user)
		end

		it 'returns nil if session key is invalid' do
			user = create :user, session_key: 'abc123'
			cookies[:session_key] = 'efg456'

			expect(helper.current_user).to eq(nil)
		end
	end

	describe 'sign_in_as' do
		it 'sets the session key'
		it 'sets the cookie'
		it 'does not set session key to the same value as cookie'
	end

	describe 'sign_out' do
		it 'does nothing if there is no current user' do
			expect(sign_out).to eq(nil)
		end
		it 'nulls the session key' do
			@current_user = create :user, session_key: 'abc123'
			sign_out
			expect(@current_user.reload.session_key).to eq(nil)
		end
		it 'deletes the cookie' do
			@current_user = create :user
			cookies[:session_key] = 'abc123'
			sign_out
			expect(cookies.key?(:session_key)).to eq(false)
		end
	end

end
