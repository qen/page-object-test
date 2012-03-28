class String
  def hyphenate
    self.split(/[^\w-]+/).join('-').downcase
  end
  
  def count_words
    self.split(/\S+/).size
  end
end