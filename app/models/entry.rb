class Entry < ActiveRecord::Base
	require Rails.root.join('lib', 'entry_content_types', 'base.rb')
	require Rails.root.join('lib', 'entry_content_types', 'url.rb')
	require Rails.root.join('lib', 'entry_content_types', 'embed.rb')
	require Rails.root.join('lib', 'entry_content_types', 'text.rb')
	require Rails.root.join('lib', 'entry_content_types', 'image.rb')
	require Rails.root.join('lib', 'entry_content_types', 'youtube.rb')
	require Rails.root.join('lib', 'entry_content_types', 'vimeo.rb')
	require Rails.root.join('lib', 'entry_content_types', 'video.rb')

	# Order is important here, the types are evaluated from top to bottom, so the least strict check should be at the bottom
	CONTENT_TYPES = {
		5 => EntryContentTypes::Video,
		4 => EntryContentTypes::Vimeo,
		3 => EntryContentTypes::Youtube,
		2 => EntryContentTypes::Image,
		1 => EntryContentTypes::Url,
		0 => EntryContentTypes::Text
	}

	belongs_to :user, inverse_of: :entries
	belongs_to :category, inverse_of: :entries

	has_many :tags, inverse_of: :entry, foreign_key: :entry_id, autosave: true
	has_many :favorites, inverse_of: :entry

	has_many :children, primary_key: :id, foreign_key: :parent_entry_id, class_name: "Entry"
	belongs_to :parent, primary_key: :id, foreign_key: :parent_entry_id, class_name: "Entry"


	validates :title, length: { minimum: 5, maximum: 64 }, allow_nil: true
	validates :content, presence: true, length: { minimum: 5, maximum: 255 }
	validates :content_type, inclusion: { in: CONTENT_TYPES.keys, message: "is not recognized" }
	validates :category, presence: true, unless: Proc.new { |e| e.category_id.nil? }

	attr_accessor :taggings

	before_validation {
		self.title = nil if self.title.blank?
		self.title = self.title.strip unless self.title.nil?
		self.content = self.content.strip unless self.content.nil?
		self.taggings = self.taggings.strip unless self.taggings.nil?
		self.category_id = nil if self.category_id.blank?

		detect_content_type
		build_tags

		true
	}

	before_create {
		self.created_at = Time.zone.now
	}

	def content_instance
		return nil unless CONTENT_TYPES.key? self.content_type
		return CONTENT_TYPES[self.content_type].new self.content
	end

	def self.process_taggings taggings, &block
		return true if taggings.blank?

		if taggings !~ /\A[a-zA-Z0-9_\- ]+\z/
			return "can only contain A-Z, 0-9, underscore (_), dash (-), and the separator space ( )"
		end

		if taggings.length > 128
			return "cannot exceed 128 characters in length"
		end

		taggings.split(' ').uniq { |tag| tag.downcase }.each do |tag|
			next if tag.blank?
			tag = tag.strip

			if tag.length > 64
				return "cannot have individual tags longer than 64 characters"
			elsif tag.length < 3
				return "cannot have individual tags shorter than 3 characters"
			end

			yield tag
		end

		true
	end

	private

		def build_tags
			
			result = Entry.process_taggings self.taggings do |tag|
				tags.build({tag_title: tag})
			end

			if result == true
				return true
			else
				errors[:taggings] << result
				return false
			end
		end

		def detect_content_type
			return false if content.blank?

			self.content_type = nil
			CONTENT_TYPES.each do |id, processor|
				if processor.is_of_type? content
					self.content_type = id
					break
				end
			end

		end
end
