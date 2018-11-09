module StatusHelper
	def status_label(status)
		status_span_generator(status)			
	end

	private
		def status_span_generator(status)
			case status
			#Job
			when 'Planned' 
				content_tag(:span, status.titleize, class: 'badge badge-primary')
			when 'Confirmed'
				content_tag(:span, status.titleize, class: 'badge badge-success')
			when 'Confirmed_by_client'
				content_tag(:span, status.titleize, class: 'badge badge-success')
			when 'No_show'
				content_tag(:span, status.titleize, class: 'badge badge-secondary')
			when 'Rejected_by_us'
				content_tag(:span, status.titleize, class: 'badge badge-danger')
			when 'Cancelled_by_client'
				content_tag(:span, status.titleize, class: 'badge badge-danger')

			#Other models
			when 'Active'
				content_tag(:span, status.titleize, class: 'badge badge-success')
			when 'Inactive'
				content_tag(:span, status.titleize, class: 'badge badge-secondary')

			end
		end
end