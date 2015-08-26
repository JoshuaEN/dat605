class UsersController < ApplicationController
	before_action :sign_in_prompt, only: [:edit, :update, :destroy]
	before_action :for_existing, only: [:edit, :update, :destroy, :ban]

	def edit

	end

	def update
		@user.assign_attributes update_params

		@user.assign_attributes(admin_update_params) if current_user.is_admin == true

		if @user.save
			flash[:success] = "Successfully Updated User"
			redirect_to back_url
		else
			render :edit
		end
	end

	def destroy

		if @user.destroy
			flash[:success] = "Successfully Deleted User #{@user.display_name}"
			redirect_to root_url
		else
			flash[:error] = "Failed to Destroy User: #{@user.errors.full_messages[0]}"
			redirect_to back_url
		end
	end

	def ban
		if current_user.is_admin != true
			unauthorized
			return
		end

		@user.with_lock do
			@user.is_banned = true
			if @user.save
				# For whatever reason rails has decided delete actually means set foriegn key reference to nil, so
				# @user.entries.delete_all
				# @user.favorites.delete_all
				Entry.where(user_id: @user.id).delete_all
				Favorite.where(user_id: @user.id).delete_all
				flash[:success] = "Successfully Banned User #{@user.display_name}"
				redirect_to root_url
			else
				raise ActiveRecord::Rollback
				flash[:error] = "Failed to Ban User: #{@user.errors.full_messages[0]}"
				redirect_to back_url
			end
		end
	end

	private

		def update_params
			params.require(:user).permit(:username, :display_name)
		end

		def admin_update_params
			params.require(:user).permit(:is_admin, :is_banned)
		end

		def for_existing
			@user = User.find_by(id: params[:id])

			return false if not_found_unless_exists @user

			if @user.id != current_user.id && current_user.is_admin != true
				unauthorized
				return false
			end
		end
end
