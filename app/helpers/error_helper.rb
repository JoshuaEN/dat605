module ErrorHelper
	
	def sign_in_prompt
		if current_user.nil?
			render 'errors/sign_in_required'
			return false
		else
			return true
		end
	end

	def not_found
		render 'errors/404', status: 404
	end

	def not_found_unless_exists object
		if object.nil?
			not_found
			return true
		else
			return false
		end
	end

	def unauthorized
		render 'errors/401', status: 401
	end

	def unauthorized_unless_admin
		if current_user.nil? || current_user.is_admin != true
			unauthorized
			return true
		else
			return false
		end
	end

	def banned
		render 'errors/banned', status: 401
	end

	def banned_unless_not
		if current_user.present? && current_user.is_banned != false
			banned
			return true
		else
			return false
		end
	end
end