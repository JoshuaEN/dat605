class Tag < ActiveRecord::Base
	belongs_to :entry, inverse_of: :tags

	validates :tag_title, presence: true, length: { minimum: 3, maximum: 64 }, format: /\A[a-zA-Z0-9_\-]+\z/
end
