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

  context "validate required title and content" do
    it "should raise error" do
      expect { subject.save! }.should raise_error
    end
  end

  context "status is unpublish" do
    subject { Page.new(params[:page]) }
    let(:published_date) { Time.now + 1.week }
    its(:is_published?) { should be_equal(false) }
    
    it "should assign a future date on is_published" do
      subject.is_published = published_date
      subject.is_published?.should be_equal(false)
      subject.published_on.to_s.should == published_date.to_s
    end
    
    it "should query the unpublished page" do
      subject.is_published = published_date
      subject.published_on.to_s.should == published_date.to_s
      subject.save

      Page.published.where(:_id => subject.id).count.should be_equal(0)
      Page.unpublished.where(:_id => subject.id).count.should be_equal(1)
    end

    it "should assign false value on is_published" do
      subject.is_published = false
      subject.is_published?.should be_equal(false)
      subject.published_on.should be(nil)
    end

  end

  context "status is published" do
    subject { Page.new(params[:page]) }
    let(:published_date) { Time.now - 1.week }
    its(:is_published?) { should be_equal(false) }

    it "should assign a past date on is_published" do
      subject.is_published = published_date
      subject.is_published?.should be_equal(true)
    end

    it "should query the published page" do
      subject.is_published = published_date
      subject.published_on.to_s.should == published_date.to_s
      subject.save

      Page.published.where(:_id => subject.id).count.should be_equal(1)
      Page.unpublished.where(:_id => subject.id).count.should be_equal(0)
    end

    it "should assign true value on is_published" do
      subject.is_published = true
      subject.is_published?.should be_equal(true)
      subject.published_on.to_s.should == (Time.now.beginning_of_day).to_s
    end
    
  end

  context "count total words" do
    subject { Page.new(params[:page]) }
    
    its(:total_words) { should be_equal( (params[:page][:title].count_words + params[:page][:content].count_words) ) }

    its(:title) { should be_equal( params[:page][:title] ) }

    its(:content) { should be_equal( params[:page][:content] ) }

  end

end
