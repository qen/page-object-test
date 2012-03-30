class ApplicationController < ActionController::Base
  protect_from_forgery

  def not_found
    #render :text => '', :status => 404
    #raise ActionController::RoutingError.new('Not Found')
    respond_to do |format|
      format.html   { render :file => "#{Rails.root}/public/404.html", :status => :not_found }
      format.xml    { head :not_found }
      format.json   { head :not_found }
    end

  end

  def api_page_error(ex)
    not_found and return if @page.nil?
    flash[:notice] = ex.to_s
    respond_with(@page, :location => api_page_url(@page.id))
  end

end
