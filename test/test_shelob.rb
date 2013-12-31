require 'minitest/autorun'
require 'webmock/minitest'
require 'shelob'

# Stub out requests

describe Shelob, "Link checking module" do
  describe "when created" do
    it "should exist" do
      Shelob.wont_be_nil
    end
  end
end

describe Shelob::Spider, "Link checking spider" do
  before do
    stub_request(:any, 'http://bmnick.com/resume').to_return(body: '<html><head><title>resume</title></head><body><a href="http://bmnick.com">home</a><a href="http://bmnick.com/resume/resume.pdf">pdf</a><a href="http://bmnick.com/resume/secret"</body></html>').times(1).then.to_return(status: 514)
    stub_request(:any, 'http://bmnick.com/').to_return(status: 200, body: '<html><head><title>pdf</title></head><body><a href="http://bmnick.com/resume/">resume</a><a href="http://bmnick.com/">home</a><a href="http://bmnick.com/resume/secret">no touchy!</a></body></html>')
    stub_request(:any, 'http://bmnick.com/resume/secret').to_return(body: '<html><head><title>secrets</title></head><body><a href="http://bmnick.com/resume/boring">boredom</a><a href="http://bmnick.com/resume">resume</a><a href="/resume/relative">relative</a></body></html>"')
    stub_request(:any, 'http://bmnick.com/resume/resume.pdf').to_return(status: 404)
    stub_request(:any, 'http://bmnick.com/resume/boring').to_return(status: 500)
    stub_request(:any, 'http://bmnick.com/resume/relative').to_return(status: 204)
  end
  describe "when created" do
    it "should exist" do
      Shelob::Spider.wont_be_nil
    end
    it "should store the initial url" do
      spider = Shelob::Spider.new("http://bmnick.com")
      spider.wont_be_nil
      spider.hostname.must_equal "http://bmnick.com"
    end
    it "should be able to take a seperate seed url" do
      spider = Shelob::Spider.new("http://bmnick.com", seed: "http://bmnick.com/resume")
      spider.wont_be_nil
      spider.hostname.must_equal "http://bmnick.com"
      spider.queue.must_include "http://bmnick.com/resume"  
    end
  end
  describe "when checking links" do
    before do

      @spider = Shelob::Spider.new("http://bmnick.com/resume")
      @results = @spider.check
    end

    it "should return an array from check" do 
      @results.must_be_kind_of Array
    end
    it "should return only error links" do
      @results.select{|r| r.status == 200}.must_be_empty
    end
    it "should provide remaining counts" do
      @spider.remaining.must_equal 0
    end
    it "should fetch the original url" do
      @spider.fetched.must_include "http://bmnick.com/resume"
    end
    it "should provide a number of urls fetched" do
      # http://bmnick.com/resume
      # http://bmnick.com/resume/resume.pdf
      # http://bmnick.com/resume/secret
      # http://bmnick.com/resume/boring
      # http://bmnick.com/resume/relative
      @spider.requests.must_equal 5
    end
    it "should make a web request for the original url" do
      assert_requested :get, "http://bmnick.com/resume"
    end
    it "should make a web request for child urls" do
      # 404
      assert_requested :get, "http://bmnick.com/resume/resume.pdf"
      @spider.fetched.must_include "http://bmnick.com/resume/resume.pdf"

      # successful
      assert_requested :get, "http://bmnick.com/resume/secret"
      @spider.fetched.must_include "http://bmnick.com/resume/secret"
    end
    it "should return the failed request" do
      # http://bmnick.com/resume/resume.pdf => 404
      # http://bmnick.com/resume/boring => 500
      @results.count.must_equal 2
    end
    it "shouldn't request pages without the prefix" do
      assert_not_requested :get, "http://bmnick.com"
    end
    it "shouldn't request pages multiple times" do
      assert_requested :get, "http://bmnick.com/resume", times: 1
    end
    it "should continue to spider down the page" do
      assert_requested :get, "http://bmnick.com/resume/boring"
      @spider.fetched.must_include "http://bmnick.com/resume/boring"
    end
    it "should support relative links" do
      assert_requested :get, "http://bmnick.com/resume/relative"
      @spider.fetched.must_include "http://bmnick.com/resume/relative"
    end
    it "should format a string cleanly" do
      @results.map{|r|r.to_s}.join("\n").must_equal "404: http://bmnick.com/resume/resume.pdf
500: http://bmnick.com/resume/boring"
    end
  end
end
