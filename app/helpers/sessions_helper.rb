module SessionsHelper

	def current_user
		@current_user ||= User.find_by_session_key(cookies[:session_key])
	end

	def current_user?
		current_user != nil
	end

	def sign_in_as user
		key = User.generate_session_key
		user.session_key = key
		user.save!
		cookies[:session_key] = key
	end

	def sign_out
		return nil if current_user.nil?

		current_user.update_attribute :session_key, nil
		cookies.delete :session_key

		true
	end
end
