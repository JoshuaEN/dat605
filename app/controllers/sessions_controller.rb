class SessionsController < ApplicationController

	skip_before_action :verify_authenticity_token, only: [:create, :failure]

	def create
		@user = User.find_by_provider_uid(auth_hash[:provider], auth_hash[:uid])

		self.params = request.env["omniauth.params"].with_indifferent_access.merge(self.params)
		if @user.nil?
			if (@user = User.build_from_auth(auth_hash[:provider], auth_hash[:uid]))

				@user.username = @user.auth_key
				@user.display_name = @user.username

				display_name = nil
				if auth_hash[:info][:nickname]
					display_name = auth_hash[:info][:nickname].gsub(/[^A-z0-9_\- ]/, '-')
					display_name = nil if display_name.size > 30
				end
				if auth_hash[:info][:name]
					username = auth_hash[:info][:name].gsub(/[^A-z0-9_\-]/, '-')
					username = nil if username.size > 20
					username = nil if username && User.exists?(username: auth_hash[:info][:name])
					
					if display_name.nil?
						display_name = username
					end
				end

				@user.username = username unless username.nil?
				@user.display_name = display_name unless display_name.nil?

				sign_in_as @user

				@user.username = nil if @user.username == @user.auth_key
				@user.display_name = nil if @user.display_name == @user.auth_key

				flash.now[:success] = "Welcome, please enter a username and display name below."

				render 'users/edit'
			else
				flash[:error] = "Failed to Create New Account: #{@user.errors.full_messages[0]}"
				redirect_to back_url
			end
		else
			sign_in_as @user
			flash[:success] = "Welcome Back #{@user.display_name}"
			redirect_to back_url
		end
	end

	def failure
		flash[:error] = "Authentication Failed: #{params[:message]}"
		redirect_to back_url
	end

	def destroy
		if sign_out.nil?
			flash[:info] = "You aren't signed in."
		else
			flash[:success] = "You've Successfully Signed Out"
		end
		redirect_to root_path
	end

	private

		def auth_hash
			request.env['omniauth.auth']
		end
end
