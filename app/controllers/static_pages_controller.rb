class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, :only => [ :landing_page ]
  def landing_page; end

  def calendar
    @events = Event.all
  end

end
