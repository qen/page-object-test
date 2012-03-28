require 'spec_helper'

describe Page do
  
  let(:params) do
    {
      :page => {
        :title    => 'foo bar %s' % (Time.new.to_f * 1000).to_i ,
        :content  => 'lorem ipsum %' % (Time.new.to_f * 1000).to_i
      }
    }
  end
  
  it "should raise error on missing parameters for page object" do
    page = Page.new({})
    expect { page.save! }.should raise_error
  end

  it "should save the page object, status is unpublish" do
    page = Page.new(params[:page])
    page.save.should == true
    page.is_published?.should == false
  end

  it "should publish/unpublish page object" do
    page = Page.new(params[:page])

    # assertions
    page.save.should == true
    page.is_published?.should == false
    page.is_published = true
    page.published_on.nil?.should == false
    page.save

    page.is_published?.should == true

    # unpublish page object
    page.is_published = false
    page.is_published?.should == false
    page.save

    page.published_on.nil?.should == true

  end

  it "should return total words correctly " do
    data = params[:page]
    page = Page.new(data)

    page.total_words.should == (data[:title].count_words + data[:content].count_words)
    page.title.should       == data[:title]
    page.content.should     == data[:content]
  end

end
