module EntryContentTypes
	class Embed < Url

		def to_html
			content_tag :div, :class => 'video-container' do
				to_iframe
			end
		end

		def to_iframe
			raise 'Not Implemented'
		end

		def embed_key
			self.class.embed_key content
		end

		def self.is_of_type? content
			super(content) && embed_key(content) != nil
		end

		def self.embed_key content
			raise "Not Implemented"
		end

		def self.title
			"Embed"
		end

	end
end