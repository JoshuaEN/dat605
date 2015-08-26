class Category < ActiveRecord::Base
	has_many :entries

	validates :title, presence: true, length: { minimum: 1, maximum: 64 }
end
