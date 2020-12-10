Milia.setup do |config|
  config.use_coupon = false
  config.use_recaptcha = true
  config.signout_to_root = true # false to return to the sign-in form (devise default)
  config.use_airbrake = false # exception_notification gem alternative

  # use invite_member for devise work-around to invite members
  # ASSUMES User model
  config.use_invite_member = true

  # whitelist tenant params list
  # example: [:name]
  config.whitelist_tenant_params = [:locale]

  # whitelist coupon params list
  # example: [:coupon]
  config.whitelist_coupon_params = [:vendor]
end
