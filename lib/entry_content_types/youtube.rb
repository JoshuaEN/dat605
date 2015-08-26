module EntryContentTypes
	class Youtube < Embed

		def to_iframe
			content_tag :iframe, src: "//www.youtube.com/embed/#{embed_key}", frameborder: 0, webkitallowfullscreen: true, mozallowfullscreen: true, allowfullscreen: true do
			end
		end

		def self.is_of_type? content
			super(content)
		end

		def self.embed_key content
			# Modified from http://stackoverflow.com/a/3726073
			return nil if (match = /\Ahttps?:\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-]+)(&(amp;)?[\w\?=]*)?\z/.match(content)).nil?
			match.captures.detect{|m| m.nil? == false}
		end

		def self.title
			"Youtube"
		end

	end
end