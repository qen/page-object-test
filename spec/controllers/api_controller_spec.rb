require 'spec_helper'

describe ApiController do
  let(:params) do
    {
      :page => {
        :title    => 'foo bar %s' % (Time.new.to_f * 1000).to_i ,
        :content  => 'lorem ipsum %s' % (Time.new.to_f * 1000).to_i
      }
    }
  end
  
  render_views

#  it "should create the page object" do 
#    Page.any_instance.stubs(:valid?).returns(true)
#    post :create, :menu_item => {:foo => 'bar'}
#    flash[:notice].should_not be_nil
#    response.body.should == [1,2]
#  end

#  it "should pass params to create" do
#    #Page.stubs(:valid?).returns(true)
#    #Page.stubs(:blahblah).returns('boo')
#    post :create, :page => expected
#    flash[:notice].should be_nil
#    assigns[:page].title.should == expected[:title]
#    puts response.body
#    #assigns[:page].title.should == expected
#    #response.body.should == {:page => expected}
#    #controller.expect_render(hash_including(:json => @json))
#  end


#  it "should fail on create page" do
#    Page.stubs(:blahblah).returns('boo')
#    post 'create', :page => { :title => 'Plain' }, :format => :'json'
#    assigns[:page].title.should == 'Plain' 
#  end 

  it "should fail on create page" do
    # mock save raise error, stubs errors
    Page.any_instance.expects(:save).raises(Exception, 'fail')
    Page.any_instance.stubs(:errors).returns(['error1'])
    
    posted_page = params[:page] 
    post :create, :page => posted_page

    response.response_code.should == 406
    assigns[:page].errors.should == ['error1']

    flash[:notice].should == ['error1']

  end

  it "should pass create page object" do
    posted_page = params[:page]
    page = Page.new(posted_page)
    
    Page.any_instance.stubs(:save!).returns(page)
    
    post :create, :page => posted_page
    assigns[:page].title.should == posted_page[:title]
    assigns[:page].content.should == posted_page[:content]

    response.response_code.should == 302
    response.should redirect_to(api_pages_url(assigns[:page].id))
  end

  it "should pass on index/display page" do
    all = [Page.first]
    Page.stubs(:all).returns(all)
    # responds to json format
    get :index, :format => :json
    assigns[:pages].should == all
    response.response_code.should == 200

    # responds to xml format
    get :index, :format => :xml
    assigns[:pages].should == all
    response.response_code.should == 200

    # any thing else its 406
    get :index
    assigns[:pages].should == all
    response.response_code.should == 406

  end

  it "should pass on update page" 

  it "should fail on update page"

  it "should pass on destroy page" 

  it "should fail on destroy page"

  it "should pass on published pages, sorted by published_on desc "
  
  it "should pass on unpublished pages, sorted by published_on desc"

  it "should pass on publishing a page"

  it "should pass on returning number of words"
  
end
