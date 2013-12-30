require "shelob/version"
require "resolver"
require "extractor"
require "set"

module Shelob
  class Spider
    attr_accessor :hostname

    def initialize hostname, options = {}
      @hostname = hostname
      @queue = [ hostname ]
      @urls = Set.new @queue
      @failures = []
      @verbose = options[:verbose] == 1 ? true : false
      @chatty = options[:verbose] == 2 ? true : false
    end

    def check
      while not @queue.empty?
        url = @queue.shift
        @urls << url

        if @verbose
          print '.'
        end

        if @chatty
          print "#{url}... "
        end

        fetch = Resolver.new(url).resolve

        @failures << fetch if fetch.status >= 400

        links = Extractor.new(fetch).extract

        filtered = links.select do |link| 
          link.start_with? @hostname and !@urls.include? link
        end

        if @chatty
          puts "checked!"
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
