module EntryContentTypes
	class Url < Base

		def to_html
			content_tag :a, rel: :nofollow, href: content do
				content
			end
		end

		def self.is_of_type? content
			(content =~ /\A#{URI::regexp(['http', 'https'])}\z/) != nil
		end

		def self.title
			"URL"
		end

	end
end