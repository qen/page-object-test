class ApiController < ApplicationController
  respond_to :xml, :json
  
  def index
    @pages = Page.all
    respond_with(@pages)
  end
  
  def create
    @page = Page.new(params[:page])
    @page.save
    flash[:notice] = 'Page was successfully created.'
    redirect_to api_pages_url(@page.id)
  rescue Exception => ex
    flash[:notice] = @page.errors
    respond_with(@page, :location => new_api_page_url)
  end
  
  def new
    @page = Page.new
    respond_with(@page)
  end
  
  def edit
    @page = Page.new
  end

  def show
    
  end

  def update

  end

  def destroy
    
  end

  
end
