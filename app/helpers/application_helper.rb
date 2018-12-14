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
end
