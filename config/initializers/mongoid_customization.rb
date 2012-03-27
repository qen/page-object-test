# read http://lostechies.com/derickbailey/2011/06/17/making-mongoid-play-nice-with-backbone-js/

module Mongoid
  module Document
    def as_json(options={})
      attrs = super(options)
      attrs["id"] = attrs["_id"].to_s
      attrs.delete('_id')
      attrs
    end
  end
end