class Page
  
  #TYPE_PUBLISHED = 1
  #include Biit::IsTypeStatus

  include Mongoid::Document
  include Mongoid::Timestamps

  set_database  :pages
  store_in      :objects

  field :title,                   :type => String
  field :content,                 :type => String
  field :typestat,                :type => Integer
  field :created_at,              :type => Time
  field :updated_at,              :type => Time
  field :published_on,            :type => Time

  index :title, :unique => true

  # VALIDATIONS
  validates :title, :content, :presence => true

  validates_uniqueness_of :title

#  set_callback(:save, :before) do |page|
#    # check if title already exists
#    if
#  end

  def as_json(options={})
    attrs = super(options)
    attrs["published_on"] = self.published_on.to_s(:dateread)
    attrs
  end

  def is_published?
    self.published_on.nil? == false
  end

  def is_published=(bool)
    return true if self.is_published? and bool == true
    self.published_on = (bool == true)? Time.now : nil
    return bool
  end

  def total_words
    self.title.to_s.count_words + self.content.to_s.count_words
  end

end
