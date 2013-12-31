require 'link_result'
require 'net/http'

module Shelob
  class Resolver
    def initialize url
      @url = url
    end

    def resolve
      begin 
        uri = URI(@url)

        resp = Net::HTTP.get_response(uri)

        LinkResult.new uri.to_s, resp.code.to_i, resp.body
      rescue Exception => e
        LinkResult.new @url, 900, e.message
      end
    end
  end
end
