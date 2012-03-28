# read http://lostechies.com/derickbailey/2011/06/17/making-mongoid-play-nice-with-backbone-js/

module Mongoid
  module Document
    
    def as_json(options={})
      options[:except] ||= []
      options[:except].push :_id
      options[:methods] ||= []
      options[:methods].push :id
      super(options)
    end

    def to_xml(options={})
      options[:except] ||= []
      options[:except].push :_id
      options[:methods] ||= []
      options[:methods].push :id
      super(options)
    end


  end
end