class ApiController < ApplicationController
  respond_to :xml, :json
  
  def index
    
  end
  
  def create
    @page = Page.new(params[:page])
    flash[:notice] = 'Page was successfully created.' if @page.valid?
    puts @page.title
    respond_with @page
  rescue Exception => ex
    render :text => '', :status => 500
  end
  
  def new
    
  end
  
  def edit
    
  end

  def show
    
  end

  def update

  end

  def destroy
    
  end

  
end
