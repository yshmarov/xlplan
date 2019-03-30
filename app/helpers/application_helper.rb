module ApplicationHelper
	def plan_label(plan)
		plan_span_generator(plan)
	end

	private
		def plan_span_generator(plan)
			case plan
				#Other models
				when 'bronze'
					content_tag(:span, plan.titleize, class: 'badge badge-danger')
				when 'silver'
					content_tag(:span, plan.titleize, class: 'badge badge-secondary')
				when 'gold'
					content_tag(:span, plan.titleize, class: 'badge badge-warning')
				when 'demo'
					content_tag(:span, plan.titleize, class: 'badge badge-info')
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
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-secondary')
				when 'client_cancelled'
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-secondary')
				when 'client_not_attended'
					content_tag(:span, I18n.t(status, scope: [:activerecord, :attributes, :event, :statuses]), class: 'badge badge-secondary')
			end
		end


end
