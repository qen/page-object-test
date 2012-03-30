require 'spec_helper'

class Page 
  extend ApiTesting

  def self.host
    #super 
    'devel.rantsfrom.me'
  end

end

describe 'Page Api Testing' do
  
  let(:params) do
    {
      :page => {
        :title    => 'foo bar %s' % (Time.new.to_f * 1000).to_i ,
        :content  => 'lorem ipsum %' % (Time.new.to_f * 1000).to_i
      }
    }
  end

  let(:get_last_page) do
    Page.api_call("/api/pages", :get).last
  end

  let(:debug_response) do
    Page.api_response.header_str
    Page.api_response.body_str
  end
  
  it "should pass on api create page object", :only => true do
    Page.api_call("/api/pages", :post, params)

    # assertions check header if status is 302
    Page.api_response.header_str.should =~ /Status: 302/
    Page.api_response.header_str.should =~ /Location:/

    debug_response
  end
  
  it "should pass on api get pages object", :only => true do
    data = Page.api_call("/api/pages", :get)
    # should have returned some data
    data.should_not be_nil
  end 

  it "should pass on update a page", :only => false do
    page    = get_last_page
    update  = params[:page]

    result  = Page.api_call("/api/pages/#{page['id']}", :put, {:page => update})

    # assert status 204 
    Page.api_response.header_str.should =~ /Status: 204/

    result = Page.api_call("/api/pages/#{page['id']}", :get)
    
    # assert data should have been updated
    result['id'].should       == page['id']
    result['title'].should    == update[:title]
    result['content'].should  == update[:content]
  end

  it "should pass on unpublish/publish page", :only => false do
    unpublished = Page.api_call("/api/pages/unpublished", :get)
    unpublished.should_not be_nil

    # publish the first record 
    page = unpublished.first
    page['published_on'].should be_nil

    result = Page.api_call("/api/pages/#{page['id']}/publish", :post)

    # veriy that the return data is the same one requested
    result['id'].should == page['id']
    result['published_on'].should_not be_nil

    # now get all published page 
    published = Page.api_call("/api/pages/published", :get)

    # the page publish should exists
    published.select {|x| x['id'] == page['id']}.count.should be_equal(1)

    #

  end

  it "should test total count words", :only => true do

    page    = get_last_page
    result  = Page.api_call("/api/pages/#{page['id']}/total_words", :get)

    expected_count_words = page['title'].count_words + page['content'].count_words

    result['count'].to_i.should be_equal(expected_count_words)

  end



 
end