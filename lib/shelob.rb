require "shelob/version"
require "resolver"
require "extractor"
require "set"

module Shelob
  class Spider
    attr_accessor :hostname

    def initialize hostname, options = {}
      # Data
      @hostname = hostname
 
      # Options
      @verbose = options[:verbose] == 1 ? true : false
      @chatty = options[:verbose] == 2 ? true : false

      # Internal
      @queue = [ hostname ]
    end

    def pre_process_notify url
      print '.' if @verbose
      print "#{url}... " if @chatty
    end

    def post_process_notify url
      puts "checked!" if @chatty
    end
    
    def fetch url
      page = Resolver.new(url).resolve

      @failures << page if page.failed

      page
    end

    def extract url
      page = fetch url

      Extractor.new(page).extract
    end

    def filter links
      links.select do |link| 
        link.start_with? @hostname
      end
    end
    
    def enqueue links
      children = filter links

      @queue.push(*children)
    end

    def finish url
      @urls << url
    end

    def process url
      links = extract url

      enqueue links

      finish url
    end

    def run_spider
      while not @queue.empty?
        url = @queue.shift

        next if @urls.include? url
        
        pre_process_notify url

        process url

        post_process_notify url
      end
    end

    def check
      # set up variables
      @urls ||= Set.new
      @failures ||= []

      # kick the spider off
      run_spider

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
