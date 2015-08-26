require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
	describe 'create' do
		include Capybara::DSL
		it 'creates a new user if nesscary' do
			expect do

				visit auth_session_path('developer')
				fill_in 'name', with: 'bobjones'
				fill_in 'nickname', with: 'bob'
				click_button 'Sign In'

			end.to change(User, :count).by(1)

			User.delete_all
		end
		it 'does not create a new user if match exists' do
			create(:user, auth_provider: 'developer', auth_uid: 'bobjones2')

			expect do

				visit auth_session_path('developer')
				fill_in 'name', with: 'bobjones2'
				fill_in 'nickname', with: 'bob'
				click_button 'Sign In'

			end.to change(User, :count).by(0)

			User.delete_all
		end


		describe 'new user creation' do
			before :all do
				@conflict_user = User.create! auth_provider: 'test', auth_uid: 'test_conflict', username: 'tomjones', display_name: 'tom'
			end
			before :each do
				u = User.find_by(auth_provider: 'developer', auth_uid: 'bobjones')
				u.delete if u

				@user = Proc.new {User.find_by_provider_uid 'developer', 'bobjones'}

				visit auth_session_path('developer')
			end
			after :all do
				User.delete_all
			end

			it 'autofills username and display_name if available' do
				
				fill_in 'name', with: 'bobjones'
				fill_in 'nickname', with: 'bob'
				click_button 'Sign In'

				user = @user.call
				expect(user.username).to eq('bobjones')
				expect(user.display_name).to eq('bob')
			end
			it 'uses the username for the display_name if no display_name is given' do

				fill_in 'name', with: 'bobjones'
				fill_in 'nickname', with: ''
				click_button 'Sign In'

				user = @user.call
				expect(user.username).to eq('bobjones')
				expect(user.display_name).to eq('bobjones')
			end
			it 'uses safe username if desired it not available' do
				fill_in 'name', with: 'tomjones'
				fill_in 'nickname', with: 'tom'
				click_button 'Sign In'

				user = User.find_by_provider_uid 'developer', 'tomjones'
				expect(user.username).to eq('developer.tomjones')
			end
			# I give up
			# it 'displays blank field if desired username was taken' do
			# 	fill_in 'name', with: 'tomjones'
			# 	fill_in 'nickname', with: 'tom'
			# 	click_button 'Sign In'
			# 	save_and_open_page
			# 	expect(find('#username').value).to eq('')
			# end
		end
	end
end
