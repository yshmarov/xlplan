module ApplicationHelper
	def plan_label(plan)
		plan_span_generator(plan)
	end

	private
		def plan_span_generator(plan)
			case plan
				#Other models
				when 'free'
					content_tag(:span, plan.titleize, class: 'badge badge-secondary')
				when 'premium'
					content_tag(:span, plan.titleize, class: 'badge badge-success')
			end
		end



	def status_label(status)
		status_span_generator(status)
	end

	private
		def status_span_generator(status)
			case status
				#Other models
				when 'active'
					content_tag(:span, status.titleize, class: 'badge badge-success')
				when 'inactive'
					content_tag(:span, status.titleize, class: 'badge badge-secondary')
				#Appointment
				when 'planned' 
					content_tag(:span, status.titleize, class: 'badge badge-primary')
				when 'confirmed'
					content_tag(:span, status.titleize, class: 'badge badge-success')
				when 'not_attended'
					content_tag(:span, status.titleize, class: 'badge badge-secondary')
				when 'member_cancelled'
					content_tag(:span, status.titleize, class: 'badge badge-secondary')
				when 'client_cancelled'
					content_tag(:span, status.titleize, class: 'badge badge-secondary')
			end
		end


end
