class Page
  
  TYPE_PUBLISHED = 1
  include Biit::IsTypeStatus

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

  def as_json(options={})
    attrs = super(options)
    attrs["published_on"] = self.published_on.to_s(:dateread)
    attrs
  end

end
