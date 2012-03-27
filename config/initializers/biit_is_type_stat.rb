# author: qen
module Biit
  module IsTypeStatus
  
    def method_missing(method_sym, *args)

      #if method_sym.to_s =~ /^is_(type|status)_([a-zA-Z0-9]+)(\?|=)$/
      if method_sym.to_s =~ /^is_(?:(type|status)_)?([a-zA-Z0-9_]+)(\?|=)$/ and self.respond_to?('typestat')
        
        # check if type constant exists
        bit = is_bit_constant_exists($1, $2)

        # should throw an error if constant is missing
        self.typestat = 0 if self.typestat.nil?
        
        it_is = ((self.typestat & bit) != 0)
        set_callback = "biit_set_#{$2}".downcase

        return it_is if $3 == '?'

        if $3 == '='
          return true if it_is and args.first == true
          self.typestat = self.typestat ^ bit

          if respond_to?(set_callback) and @callback.nil?
            @callback = true # prevents recursive call back
            send(set_callback.to_sym, args.first, $1)
            @callback = nil
          end
          
          return ((self.typestat & bit) != 0)
        end

      else
        super
      end
    end

    def respond_to?(method_sym, include_private = false)

      #if method_sym.to_s =~ /^is_(type|status)_([a-zA-Z0-9]+)(\?|=)$/
      if method_sym.to_s =~ /^is_(?:(type|status)_)?([a-zA-Z0-9_]+)(\?|=)$/ and self.respond_to?('typestat')
        is_bit_constant_exists($1, $2)
        true
      else
        super
      end

    rescue
      super
    end

    private
    def is_bit_constant_exists(prefix, varname)
      bit = 'type'
      if not prefix.nil?
        bit = prefix
        raise "#{self.class.to_s}"+"::#{bit}_#{varname}".upcase + " not defined" if not self.class.const_defined?("#{bit}_#{varname}".upcase)
      else
        bit = 'status' if not self.class.const_defined?("#{bit}_#{varname}".upcase)
        raise "#{self.class.to_s}"+"::(TYPE|STATUS)_#{varname}".upcase + " not defined" if not self.class.const_defined?("#{bit}_#{varname}".upcase)
        #return false if not self.class.const_defined?("#{bit}_#{varname}".upcase)
      end

      (self.class.to_s + "::#{bit}_#{varname}".upcase).constantize
    end
    
  end
end