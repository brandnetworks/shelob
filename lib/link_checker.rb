require "link_checker/version"
require "resolver"
require "extractor"
require "set"

module LinkChecker
  class Spider
    attr_accessor :hostname

    def initialize hostname
      @hostname = hostname
      @queue = [ hostname ]
      @urls = ::Set.new @queue
      @failures = []
    end

    def check
      while not @queue.empty?
        url = @queue.shift
        @urls << url

        fetch = Resolver.new(url).resolve

        @failures << fetch if fetch.status >= 400

        links = Extractor.new(fetch).extract

        filtered = links.select do |link| 
          link.start_with? @hostname and !@urls.include? link
        end

        @queue.push(*filtered)
      end

      @failures
    end

    def remaining
      return @queue.count
    end

    def requests
      return @urls.count
    end
    
    def fetched
      return @urls
    end
  end
end
