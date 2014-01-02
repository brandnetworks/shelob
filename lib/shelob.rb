require "shelob/version"
require "resolver"
require "extractor"
require "set"

module Shelob
  # This is the central workhorse class of Shelob. It takes
  # a url, fetches it, and then spiders through any
  # children of that url and fetches them as well.
  class Spider
    # The root url which this Spider instance is working
    # underneath
    attr_accessor :hostname

    # The current queue of urls to check
    attr_accessor :queue

    # Create a new spider with the given hostname and
    # options
    #
    # Valid options:
    # * verbose: 0 for no output, 1 for progress output, 2
    #   for verbose output
    # * seed: Provide an initial seed value, other than the
    #   root url you're providing
    # * throttle: Throttle requests down to x requests per 
    #   minute
    def initialize hostname, options = {}
      # Data
      @hostname = hostname

      # Options
      @verbose = options[:verbose] == 1 ? true : false
      @chatty = options[:verbose] == 2 ? true : false
      @throttle = options[:throttle] ? 60 / options[:throttle] : 0

      # Internal
      if options[:seed].nil?
        @queue = [ hostname ]
      else
        @queue = [ options[:seed] ]
      end
    end

    # Entry point to the main spider process. This is the
    # main API point, and will return once the site has
    # been completely spidered.
    #
    # Returns a list of all failed urls, and their
    # particular error code (404, 500, etc.)
    def check
      # set up variables
      @urls ||= Set.new
      @failures ||= []

      # kick the spider off
      run_spider

      @failures
    end

    # Returns a count of the remaining urls to parse - this
    # number is only a view of the current state, as more
    # urls are constantly being added as other urls
    # resolve.
    #
    # This would only be useful to call from another thread
    # at this time, as check is a blocking call
    def remaining
      return @queue.count
    end

    # Return the total number of urls that were fetched in
    # the spidering process.
    def requests
      return @urls.count
    end

    # Return an array of all urls that were fetched in the
    # process of spidering the site.
    def fetched
      return @urls
    end

    # Notify that a url is about to be processed. Currently
    # only used to print status
    def pre_process_notify url
      print "#{url}... " if @chatty
    end

    # Notify that a url has just been processed. Currently
    # only used to print status
    def post_process_notify url
      print '.' if @verbose
      puts "checked!" if @chatty
    end

    # Load a page from the internet, appending it to the
    # failures array if the fetch encountered an error.
    #
    # Returns a LinkResult with the results of fetching the
    # page.
    def fetch url
      page = Resolver.new(url).resolve

      @failures << page if page.failed?

      page
    end

    # Extract links from the given url.
    #
    # Returns an array of all link targets on the page.
    def extract url
      page = fetch url

      Extractor.new(page).extract
    end

    # Filter links to ensure they are children of the root
    # url, and removes duplicates
    def filter links
      links.select do |link|
        link.start_with? @hostname
      end.uniq
    end

    # Add the given links to our internal queue to ensure
    # they are checked.
    def enqueue links
      children = filter links

      @queue.push(*children)
    end

    # Signal that processing is done on a given url, so
    # that it won't be checked again
    def finish url
      @urls << url
    end

    # Given a url, fetch it, extract all links, and enqueue
    # those links for later processing.
    def process url
      links = extract url

      enqueue links

      finish url
    end

    # Internal helper method to kick off the spider once
    # everything has been properly configured.
    def run_spider
      while not @queue.empty?
        url = @queue.shift

        next if @urls.include? url

        sleep @throttle

        pre_process_notify url

        process url

        post_process_notify url
      end
    end
  end
end
