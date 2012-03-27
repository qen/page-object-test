class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_found
    #render :text => '', :status => 404
    raise ActionController::RoutingError.new('Not Found')
  end

end
