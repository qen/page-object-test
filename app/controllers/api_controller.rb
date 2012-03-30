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
    #respond_with(@page, :location => api_page_url(@page.id))
    redirect_to api_page_url(@page.id)
    
  rescue Exception => ex
    flash[:notice] = @page.errors
    respond_with(@page, :location => new_api_page_url)
  end
  
  def new
    @page = Page.new
    respond_with(@page)
  end
  
  def edit
    @page = Page.find(params[:id])
    respond_with(@page)
  rescue Exception => ex
    api_page_error ex
  end

  def show
    @page = Page.find(params[:id])
    respond_with(@page)
  rescue Exception => ex
    api_page_error ex
  end
 
  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])
    respond_with(@page)
  rescue Exception => ex
    api_page_error ex
  end

  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    respond_with(@page)
  rescue Exception => ex
    api_page_error ex
  end

  def get_published
    @pages = Page.published
    respond_with(@pages)
  end

  def get_unpublished
    @pages = Page.unpublished
    respond_with(@pages)
  end

  def get_total_words
    @page = Page.find(params[:id])
    @total_words = @page.total_words
    respond_with({:count => @total_words})
  rescue Exception => ex
    api_page_error ex
  end

  def do_publish
    @page = Page.find(params[:id])
    @page.is_published = ( params[:date] || true )
    @page.save
    respond_with(@page, :location => api_page_url(@page.id))
  rescue Exception => ex
    api_page_error ex
  end
  
end
