module EntryContentTypes
	class Text < Base

		def to_html
			content_tag :p do
				content
			end
		end

		def self.is_of_type? content
			true
		end

		def self.title
			"Text"
		end

	end
end