class ApplicationController < ActionController::Base
	include SessionsHelper
	include ErrorHelper

	helper_method :back_url, :current_url

	protect_from_forgery with: :exception

	before_action :check_for_ban
	before_action :set_content_security_policy_headers

	# From https://gist.github.com/Stex/5539836
	# I wonder why rails doesn't build something like this into the form field helpers.
	# This is needed to prevent the materialize css labels from breaking.
	ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
		if html_tag =~ /<(input|label|textarea|select)/
			html_field = Nokogiri::HTML::DocumentFragment.parse(html_tag)
			html_field.children.add_class 'field_with_errors'
			html_field.to_s.html_safe
		else
			html_tag
		end
	end

	def back_url
		return @back_url if @back_url

		back = nil
		if params.key? :back
			back = params[:back]
		elsif request.referer
			back = request.referer
		end

		if back.nil? || is_url_safe_for_redirect?(back) != true || is_url_logical_for_redirect?(back) != true
			@back_url = root_path
		else
			@back_url = back
		end

		return @back_url
	end

	def current_url
		return @current_url if @current_url

		@current_url = request.original_url
	end

	protected

		def check_for_ban
			return false if banned_unless_not == true
			true
		end

		def is_url_safe_for_redirect? url
			uri = URI.parse(url) rescue nil

			return false if uri.nil?

			return false unless uri.is_a? URI::HTTP

			return false unless uri.host == request.host

			true
		end

		def is_url_logical_for_redirect? url
			uri = URI.parse(url) rescue nil

			return false if uri.path.start_with?('/auth')

			true
		end

		def set_content_security_policy_headers
			response.headers['Content-Security-Policy'] = ''+
				"default-src 'none'; "+
				"img-src *; " +
				"child-src http://player.vimeo.com https://player.vimeo.com http://www.youtube.com https://www.youtube.com; " +
				"font-src 'self' https://fonts.googleapis.com https://fonts.gstatic.com;" +
				"media-src *; " +
				"reflected-xss block; " +
				"script-src 'self'; " +
				"style-src 'self' https://fonts.googleapis.com;"
		end
end
