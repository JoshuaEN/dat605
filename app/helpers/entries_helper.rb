module EntriesHelper

	def entry_replies_link entry
		link_to entry_path(entry), :class => 'btn-flat waves-effect waves-green' do
			"#{(@replies[entry.id] || 0)} Replies"
		end
	end

	def entry_favorites_link entry
		if @user_favorites.index entry.id
			link_to entry_unfavorite_path(entry), method: :post, :class => 'btn-flat waves-effect waves-red amber-text text-darken-3' do
				"#{@favorites[entry.id] || 0} Favorites"
			end
		else
			link_to entry_favorite_path(entry), method: :post, :class => 'btn-flat waves-effect waves-green' do
				"#{@favorites[entry.id] || 0} Favorites"
			end
		end
	end

	def entry_tags_link entry
		if tags = @tags[entry.id]
			(link_to search_path(taggings: tags*' '), data: {activates: "entry#{entry.id}-taglist"}, :class => 'dropdown-button btn-flat' do
				"#{tags.size} Tags"
			end) + 

			(content_tag :ul, id: "entry#{entry.id}-taglist", :class => 'dropdown-content' do
				
				(content_tag :li do
					link_to 'All Tags', search_path(taggings: tags*' ')
				end) + 

				(content_tag :li, :class => 'divider' do 
				end) + 

				(tags.map do |tag|
					content_tag :li do
						link_to tag, search_path(taggings: tag)
					end
				end.join('').html_safe)
			end)
		else
			content_tag :button, '0 Tags', :class => 'btn-flat disabled', disabled: true
		end
	end

	def entry_delete_link entry
		if can_delete? entry
			link_to entry_path(entry), data: { confirm: 'Are you sure you want to delete this entry?'}, method: :delete, :class => 'btn-flat waves-effect waves-red red-text lighten-3' do
				'Delete'
			end
		end
	end

	def entry_author_link entry
		if current_user && entry.user_id == current_user.id
			content_tag :button, 'by me', :class => 'btn-flat disabled purple-text text-lighten-2', disabled: true
		else
			(link_to '#', data: {activates: "entry#{entry.id}-userdropdown"}, :class => 'dropdown-button btn-flat' do
				"by #{@users[entry.user_id].display_name}"
			end) + 

			(content_tag :ul, id: "entry#{entry.id}-userdropdown", :class => 'dropdown-content' do
				
				(content_tag :li do
					link_to @users[entry.user_id].username, '#'
				end) + 

				( current_user && current_user.is_admin == true ? 
					(content_tag :li, :class => 'divider' do 
					end) + 

					(content_tag :li do
						link_to 'Edit User', edit_user_path(@users[entry.user_id])
					end)
					:
					nil
				)
			end)
		end
	end
end
