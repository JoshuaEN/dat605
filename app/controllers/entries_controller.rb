class EntriesController < ApplicationController

	before_action :sign_in_prompt, only: [:new, :create, :destroy, :favorite, :unfavorite]
	before_action :for_existing, only: [:show, :destroy]

	helper_method :can_delete?

	def index
		@entries = Entry.order("created_at desc") # TODO: Paginate and filtering

		if params.key? :search

			if params[:taggings].present?
				tags = []
				result = Entry.process_taggings params[:taggings] do |tag|
					tags.push tag.downcase
				end

				if result == true
					# Use a second query, rather than a join, because join creates a lot of unwanted rows we have to remove later.
					# Also, while it would have been great to have an actual index to work from, that isn't something that rails supports an interface for
					# and I need to avoid raw SQL because I'm using two different RDMSs
					@entries = @entries.where(id: 
						Tag.where("lower(tag_title) in (?)", tags).pluck(:entry_id)
					)
				else
					flash[:warning] = "Tags Ignored: Tags #{result}"
				end
			end

			if params[:category_id].present?
				category_id = params[:category_id].to_i

				if category_id == -1
					category_id = nil
				end

				@entries = @entries.where(category_id: category_id)
			end

		else
			@entries = @entries.where(parent_entry_id: nil)
		end


		entry_ids = @entries.map(&:id)

		@favorites = favorite_counts_for_entries entry_ids

		@replies = reply_counts_for_entries entry_ids

		@user_favorites = user_favorites_for_entries entry_ids

		@tags = tags_for_entries entry_ids

		user_ids = @entries.map(&:user_id).uniq
		@users = users_for_entries user_ids

		@entries = @entries.page(params[:page])
	end

	def show
		@parent = Entry.find_by(id: @entry.parent_entry_id) if @entry.parent_entry_id

		@entries = Entry.where(parent_entry_id: @entry.id).order("created_at desc")

		entry_ids = @entries.map(&:id)

		entry_ids.push(@parent.id) if @parent

		@replies = reply_counts_for_entries entry_ids
		@replies[@entry.id] = @entries.size

		entry_ids.push(@entry.id)


		@favorites = favorite_counts_for_entries entry_ids

		@user_favorites = user_favorites_for_entries entry_ids

		@tags = tags_for_entries entry_ids

		user_ids = @entries.map(&:user_id).push(@entry.user_id)
		user_ids.push(@parent.user_id) if @parent
		user_ids = user_ids.uniq
		@users = users_for_entries user_ids

		@entries = @entries.page(params[:page])
		params[:back] ||= current_url
	end

	def new
		@entry = Entry.new
		@entry.parent_entry_id = params[:parent_entry_id]
	end

	def create
		@entry = Entry.new create_params
		@entry.user_id = current_user.id

		@entry.category_id = @entry.parent.category_id if @entry.parent_entry_id

		if @entry.save
			flash[:success] = "Successfully Created Entry"
			redirect_to back_url
		else
			render :new
		end
	end

	def destroy
		if can_delete?(@entry) != true
			unauthorized
			return
		end

		if @entry.destroy
			flash[:success] = "Successfully Destroyed Entry"
			redirect_to back_url
		else
			flash[:error] = "Failed to Destroy Entry: #{@entry.errors.full_messages[0]}"
			redirect_to back_url
		end
	end

	def favorite
		# To the point of: Don't use exceptions for flow control.
		# This hits the database once, hitting it twice, once to check if the favorite already exists
		# and once to do the insert if it doesn't
		# which due to concurrency might still cause an exception

		begin
			Favorite.create! entry_id: params[:entry_id], user_id: current_user.id
			flash[:success] = "Entry Favorited"
		rescue ActiveRecord::RecordNotUnique
			flash[:success] = "Entry already favorited"
		rescue ActiveRecord::InvalidForeignKey
			flash[:error] = "Entry no longer exist"
		end

		redirect_to back_url
	end

	def unfavorite
		if Favorite.where(entry_id: params[:entry_id], user_id: current_user.id).delete_all == 1
			flash[:success] = "Entry Unfavorited"
		else
			flash[:success] = "Entry already unfavorited"
		end

		redirect_to back_url
	end

	protected

		def can_delete? entry
			if current_user && (entry.user_id == current_user.id || current_user.is_admin == true)
				true
			else
				false
			end
		end

	private

		def create_params
			params.require(:entry).permit(:title, :content, :category_id, :taggings, :parent_entry_id)
		end


		def for_existing
			@entry = Entry.find_by(id: params[:id])

			return false if not_found_unless_exists @entry
		end

		def favorite_counts_for_entries entry_ids
			Hash[Favorite.where(entry_id: entry_ids).select("entry_id, count(*) as count").group("entry_id").map{|fav| [fav.entry_id, fav.count]}]
		end

		def reply_counts_for_entries entry_ids
			Hash[Entry.where(parent_entry_id: entry_ids).select("parent_entry_id, count(*) as count").group("parent_entry_id").map{|reply| [reply.parent_entry_id, reply.count]}]
		end

		def user_favorites_for_entries entry_ids
			if current_user
				Favorite.where(entry_id: entry_ids, user_id: current_user.id).pluck(:entry_id)
			else
				[]
			end
		end

		def tags_for_entries entry_ids
			entry_tags = {}
			Tag.where(entry_id: entry_ids).each do |tag|
				unless entry_tags.key? tag.entry_id
					entry_tags[tag.entry_id] = []
				end

				entry_tags[tag.entry_id].push tag.tag_title
			end

			entry_tags
		end

		def users_for_entries user_ids
			Hash[User.where(id: user_ids).select(:id, :display_name, :username).map{|u| [u.id, u]}]
		end
end
