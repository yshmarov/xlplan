module LocationsHelper
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
				#Job
				when 'planned' 
					content_tag(:span, status.titleize, class: 'badge badge-primary')
				when 'confirmed'
					content_tag(:span, status.titleize, class: 'badge badge-success')
				when 'confirmed_by_client'
					content_tag(:span, status.titleize, class: 'badge badge-success')
				when 'not_attended'
					content_tag(:span, status.titleize, class: 'badge badge-danger')
				when 'rejected_by_us'
					content_tag(:span, status.titleize, class: 'badge badge-secondary')
				when 'cancelled_by_client'
					content_tag(:span, status.titleize, class: 'badge badge-secondary')
			end
		end

end