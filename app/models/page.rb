class Page
  
  #TYPE_PUBLISHED = 1
  #include Biit::IsTypeStatus

  include Mongoid::Document
  include Mongoid::Timestamps

  set_database  :pages
  store_in      :objects

  field :title,                   :type => String
  field :content,                 :type => String
  #field :typestat,                :type => Integer
  field :created_at,              :type => Time
  field :updated_at,              :type => Time
  field :published_on

  index :title, :unique => true
  index :published_on

  # VALIDATIONS
  validates :title, :content, :presence => true

  validates_uniqueness_of :title

  # returns true if page is published
  def is_published?
    self.published_on.nil? == false
  end

  # setter for published document, true assigns time in published_on field
  # otherwise its nil
  def is_published=(value)
    # check if value is parsable date
    begin
      published_date = Time.parse(value)
    rescue
      # otherwise evaluate value, true or false
      published_date = Time.now if value
    end

    self.published_on = published_date
  end

  # get combined total words of title and content
  def total_words
    self.title.to_s.count_words + self.content.to_s.count_words
  end

  # scopes
  class << self
    def published
      today = Time.now
      where(:published_on => {:'$lte' => today.end_of_day}).desc(:published_on)
    end

    def unpublished
      today = Time.now
      where(:'$or' => [{:'published_on' => nil}, {:'published_on' => {:'$gte' => today.end_of_day}}] ).desc(:published_on)
    end
  end

end
