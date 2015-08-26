module EntryContentTypes
	class Image < Url

		def to_html
			tag(:img, src: content, :class => 'responsive-img')
		end

		def self.is_of_type? content
			super(content) && (content =~ /\.(?:jpg|jpeg|png|gif|svg)\z/) != nil
		end

		def self.title
			"Image"
		end

	end
end