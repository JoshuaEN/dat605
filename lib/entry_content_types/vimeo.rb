module EntryContentTypes
	class Vimeo < Embed

		def to_iframe
			content_tag :iframe, src: "//player.vimeo.com/video/#{embed_key}", frameborder: 0, webkitallowfullscreen: true, mozallowfullscreen: true, allowfullscreen: true do
			end
		end

		def self.is_of_type? content
			super(content)
		end

		def self.embed_key content
			return nil if (match = /\Ahttps?:\/\/(?:www.)?vimeo.com\/(?:channels\/\S+\/|groups\/\S+\/videos\/)?([0-9]+)\/?(?:(?:\?\S*)\z|\z)/.match(content)).nil?

			match.captures.detect{|m| m.nil? == false}
		end

		def self.title
			"Vimeo"
		end

	end
end