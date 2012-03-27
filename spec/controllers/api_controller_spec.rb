require 'spec_helper'

describe ApiController do
  let(:expected) { {:id => 1, :title => "test"} }
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


  it "should pass params to page" do
    Page.stubs(:blahblah).returns('boo')
    post 'create', :page => { :title => 'Plain' }, :format => :'json'
    assigns[:page].title.should == 'Plain'
  end

  it "should validate params passed to page"

  it "should create page object"
  
end
