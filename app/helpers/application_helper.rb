module ApplicationHelper
	def get_title
		title = "DAT605"
		if content_for? :title
			return "#{content_for :title} - #{title}"
		else
			return title
		end
	end

	def label_class_helper value
		if value.blank?
			return {}
		else
			return { :class => 'active'}
		end
	end

	def render_form_errors f
		return nil if f.nil? || f.object.nil? || f.object.errors.count == 0

		render partial: 'errors/form_errors', locals: { errors: f.object.errors.full_messages }
	end

	def back_tag
		hidden_field_tag :back, back_url
	end
end
