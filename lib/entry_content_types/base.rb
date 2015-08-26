module EntryContentTypes
	class Base
		include ActionView::Helpers::TagHelper
		include ActionView::Context

		def initialize content
			@content = content
		end

		def to_html
			raise "Not Implemented"
		end

		def content
			@content
		end

		def is_valid?
			self.class.is_of_type? content
		end

		def title
			self.class.title
		end

		def self.is_of_type? content
			raise "Not Implemented"
		end

		def self.title
			raise "Not Implemented"
		end

	end
end