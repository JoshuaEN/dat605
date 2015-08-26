class Favorite < ActiveRecord::Base
	belongs_to :user
	belongs_to :entry

	# Datebase validates this for us.
	# validates :user, presence: true
	# validates :entry, presence: true
end
