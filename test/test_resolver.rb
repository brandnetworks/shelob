require 'minitest/autorun'
require 'webmock/minitest'
require 'resolver'
require 'link_result'

WebMock.allow_net_connect!

describe Shelob::Resolver, "Link fetching module" do 
  describe "when created" do
    it "should be created with a url" do
      Shelob::Resolver.new("http://bmnick.com/ruby-c-extensions") 
    end

    it "should return an error result for bad URIs" do
      resolver = Shelob::Resolver.new("http://bmnick.com/bad uri")
      res = resolver.resolve
      res.failed?
    end 
  end

  describe "when used" do
    before do
      @resolver = Shelob::Resolver.new("http://bmnick.com/ruby-c-extensions")
      @result = @resolver.resolve
    end

    it "should return a LinkResult" do
      @result.must_be_kind_of LinkResult
    end

    it "should return live result" do
      @result.body.must_match(/CExt/)
    end

  end
      
end
