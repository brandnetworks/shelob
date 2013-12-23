require 'link_result'
require 'net/http'

module LinkChecker
  class Resolver
    def initialize url
      @uri = URI(url)
    end

    def resolve
      resp = Net::HTTP.get_response(@uri)

      LinkResult.new @uri.to_s, resp.code.to_i, resp.body
    end
  end
end
