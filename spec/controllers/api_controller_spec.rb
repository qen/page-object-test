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
    
    post :create, :page => posted_page, :format => :json
    assigns[:page].title.should == posted_page[:title]
    assigns[:page].content.should == posted_page[:content]

    #puts api_page_url(assigns[:page].id)
    
    response.response_code.should == 302
    response.should redirect_to(api_page_url(assigns[:page].id))
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

  it "should pass on update page"  do
    # mock update_attributes ok
    Page.any_instance.expects(:update_attributes).returns(true)
    page_first = Page.first
    put :update, :page => params[:page], :id => page_first.id, :format => :json
    assigns[:page].should == page_first
    flash[:notice].should be_nil
    response.response_code.should == 204

    page_first = Page.first
    # mock object failure
    Page.expects(:find).raises(Exception, 'fail')
    put :update, :page => params[:page], :id => 23123213, :format => :json
    flash[:notice].should_not be_nil
    response.response_code.should == 204
  end

  it "should pass on destroy page" do
    # mock destroy ok
    Page.any_instance.expects(:destroy).returns(true)
    page_first = Page.first
    delete :destroy, :page => params[:page], :id => page_first.id, :format => :json
    assigns[:page].should == page_first
    flash[:notice].should be_nil
    response.response_code.should == 204

    page_first = Page.first
    # mock object failure
    Page.expects(:find).raises(Exception, 'fail')
    delete :destroy, :page => params[:page], :id => 23123213, :format => :json
    flash[:notice].should_not be_nil
    response.response_code.should == 204
  end

  it "should pass on get published pages, sorted by published_on desc " do
    # mock published ok
    Page.expects(:published).returns(true)
    get :get_published, :format => :json
    assigns[:pages].should        == true
    response.response_code.should == 200
  end
  
  it "should pass on get unpublished pages, sorted by published_on desc" do
    # mock unpublished ok
    Page.expects(:unpublished).returns(true)
    get :get_unpublished, :format => :json
    assigns[:pages].should        == true
    response.response_code.should == 200
  end

  it "should pass on returning number of words" do
    # mock page
    page = mock()
    page.expects(:total_words).returns(1)
    Page.expects(:find).returns(page)
    get :get_total_words, :id => 'i was mocked!', :format => :json
    assigns[:total_words].should  == 1
    response.response_code.should == 200
  end

  
  it "should pass on publishing a page" do
    date = Time.now + 1.week
    page_first = Page.first

    # publish page here
    post :do_publish, :id => page_first.id, :date => date, :format => :json
    assigns[:page].should         == page_first
    assigns[:page].is_published?  == true
    assigns[:page].published_on   == date
    response.response_code.should == 201

    # unpublish page here
    post :do_publish, :id => page_first.id, :date => false, :format => :json
    puts flash[:notice]
    assigns[:page].should         == page_first
    assigns[:page].is_published?  == false
    assigns[:page].published_on.should be_nil
    response.response_code.should == 201

  end

end
