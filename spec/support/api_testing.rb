# http://stackoverflow.com/questions/752636/best-way-to-test-rails-rest-xml-api
# author: muirbot

module ApiTesting
  # requres the json, curb, and addressable gems

  require "addressable/uri"
  @response = nil

  def host
    'localhost:3000'
  end

  def api_response
    @response
  end

  def api_call(path, verb, query_hash={}, options={})
    options.reverse_merge! :api_key => "abc1234", :format => "json"
    query_hash.reverse_merge!({:api_key => options["api_key"]}) if options[:api_key]
    query = to_query_string(query_hash)
    full_path = "http://#{self.host}/#{path}.#{options[:format]}?#{query}"
    @response = case verb
      when :get
        Curl::Easy.perform(full_path)
      when :post
        Curl::Easy.http_post("http://#{self.host}/#{path}.#{options[:format]}", query)
      when :put
        Curl::Easy.http_put(full_path, query)
      when :delete
        Curl::Easy.http_delete(full_path)
    end
    
    case options[:format]
      when "xml"
        Hash.from_xml(@response.body_str) rescue nil
      when "json"
        JSON.parse(@response.body_str) rescue nil
    end
  end

  private

  def to_query_string(val)
    uri = Addressable::URI.new
    uri.query_values = val
    uri.query
  end

end