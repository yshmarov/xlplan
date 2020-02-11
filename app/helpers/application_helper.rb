module ApplicationHelper
	include Pagy::Frontend

	def gender_label(gender)
		case gender
			when 'undisclosed'
	      "<i class='fa fa-question'></i>".html_safe
			when 'male'
	      "<i class='fa fa-mars'></i>".html_safe
			when 'female'
	      "<i class='fa fa-venus'></i>".html_safe
		end
	end

	def model_icon(model_name)
		case model_name
			when 'Settings'
	      "<i class='fa fa-cog'></i>".html_safe
			when 'User'
	      "<i class='fa fa-user'></i>".html_safe
			when 'Location'
	      "<i class='fa fa-map-marker-alt'></i>".html_safe
			when 'Service'
	      "<i class='far fa-hand-paper'></i>".html_safe
			when 'Time'
	      "<i class='far fa-clock'></i>".html_safe
			when 'Member'
	      "<i class='fa fa-user-tie'></i>".html_safe
			when 'Client'
	      "<i class='far fa-id-card'></i>".html_safe
		end
	end

	def plan_label(plan)
		plan_span_generator(plan)
	end

	def role_label(name)
		role_span_generator(name)
	end

	def status_label(status)
		status_span_generator(status)
	end

	def active_label(active)
		active_span_generator(active)
	end

	private
		def active_span_generator(active)
			case active
				#Other models
				when true
					content_tag(:span, "yes", class: 'badge badge-success')
				when false
					content_tag(:span, "no", class: 'badge badge-danger')
			end
		end

		def plan_span_generator(plan)
			case plan
				#Other models
				when 'demo'
					content_tag(:span, plan.titleize, class: 'badge badge-info')
				when 'bronze'
					content_tag(:span, plan.titleize, class: 'badge badge-danger')
				when 'silver'
					content_tag(:span, plan.titleize, class: 'badge badge-secondary')
				when 'gold'
					content_tag(:span, plan.titleize, class: 'badge badge-warning')
				when 'blocked'
					content_tag(:span, plan.titleize, class: 'badge badge-primary')
			end
		end

		def role_span_generator(name)
			case name
				#Other models
				when 'admin'
					content_tag(:span, name.titleize, class: 'badge badge-dark')
				when 'manager'
					content_tag(:span, name.titleize, class: 'badge badge-primary')
				when 'specialist'
					content_tag(:span, name.titleize, class: 'badge badge-info')
				when 'owner'
					content_tag(:span, name.titleize, class: 'badge badge-secondary')
			end
		end

	  #I18n.t(event.status, scope: [:activerecord, :attributes, :event, :statuses])
		def status_span_generator(status)
			case status
				#Event
				when 'planned' 
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-primary')
				when 'confirmed'
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-success')
				when 'member_cancelled'
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-danger')
				when 'client_cancelled'
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-danger')
				when 'no_show'
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-danger')
				when 'no_show_refunded'
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-success')
			end
		end
end