require 'rubygems'
require 'nokogiri'

module Shelob
  class Extractor
    def initialize fetched
      @fetched = fetched
    end

    def extract
      content = Nokogiri::HTML(@fetched.body)
      raw = content.css('a').map { |anchor| anchor['href'] }
      raw.map do |link| 
        if link.start_with? '/' 
          u = URI(@fetched.url)
          "#{u.scheme}://#{u.host}#{link}"
        else
          link
        end
      end
    end
  end
end
