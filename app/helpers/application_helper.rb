module ApplicationHelper
	def plan_label(plan)
		plan_span_generator(plan)
	end

	def role_label(name)
		role_span_generator(name)
	end

	private
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

	def status_label(status)
		status_span_generator(status)
	end

  #I18n.t(event.status, scope: [:activerecord, :attributes, :event, :statuses])
	private
		def status_span_generator(status)
			case status
				#Other models
				when 'active'
					content_tag(:span, status.titleize, class: 'badge badge-success')
				when 'inactive'
					content_tag(:span, status.titleize, class: 'badge badge-secondary')
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