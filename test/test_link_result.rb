require 'minitest/autorun'
require 'link_result'

describe LinkResult, "Link fetch result" do
  before do
    @result = LinkResult.new("http://google.com", 200, '<html><head><title>hi</title></head><body><a href="http://bing.com">bing</a><a href="http://yahoo.com">yahoo</a></body></html>')
    @failed = LinkResult.new("http://google.com", 404, 'Not found')
  end

  describe "when created" do
    it "should take three arguments" do
      @result.wont_be_nil
    end

    it "should save arguments" do
      @result.url.must_equal "http://google.com"
      @result.status.must_equal 200
      @result.body.must_equal '<html><head><title>hi</title></head><body><a href="http://bing.com">bing</a><a href="http://yahoo.com">yahoo</a></body></html>'
    end

    it "should be immutable" do
      proc { @result.status = 404 }.must_raise NoMethodError
    end

    it "should have a clean string rep" do
      @result.to_s.must_equal "200: http://google.com"
    end

    it "should determine if a request is failed" do
      @result.failed?.must_equal false
      @failed.failed?.must_equal true
    end

  end

  describe "exception cases" do

    it "should be aware of the 900 = Exception rule in to_s" do
      res = LinkResult.new("http://google.com/bad uri", 900, 'undefined local variable or method `url` for blah')
      res.to_s.must_equal 'Exception: http://google.com/bad uri'
    end

  end
end

