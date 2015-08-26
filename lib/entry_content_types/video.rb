module EntryContentTypes
	class Video < Url

		def to_html
			content_tag :video, src: content, :class => 'responsive-video', controls: true do
			end
		end

		def self.is_of_type? content
			super(content) && (content =~ /\.(?:webm|oog|mp4)\z/) != nil
		end

		def self.title
			"HTML5 Video"
		end

	end
end