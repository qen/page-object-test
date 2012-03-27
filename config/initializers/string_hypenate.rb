class String
  def hyphenate
    self.split(/[^\w-]+/).join('-').downcase
  end
end