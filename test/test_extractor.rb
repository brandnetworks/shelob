require 'minitest/autorun'
require 'extractor'
require 'link_result'

describe LinkChecker::Extractor, "Link extracting module" do

  describe "when created" do
    it "should be created with a LinkResult" do
      le = LinkResult.new("http://google.com", 200, '<html><head><title>resume</title></head><body><a href="http://bmnick.com">home</a><a href="http://bmnick.com/resume/resume.pdf">pdf</a></body></html>')
      le.wont_be_nil
    end
  end

  describe "when used" do
    before do
      @result = LinkResult.new("http://google.com", 200, '<html><head><title>hi</title></head><body><a href="http://bing.com">bing</a><a href="http://yahoo.com">yahoo</a></body></html>')
      @result2 = LinkResult.new("http://google.com/something", 200, '<html><head><title>hi</title></head><body><a href="/about">about</a></body></html>')
      @le = LinkChecker::Extractor.new(@result)
      @le2 = LinkChecker::Extractor.new(@result2)
    end

    it "should return a list of the links in the page" do
      extracts = @le.extract 
      extracts.must_be_kind_of Array
      extracts.must_equal ["http://bing.com", "http://yahoo.com"]
    end

    it "should transform relative links to absolute" do
      extracts = @le2.extract
      extracts.must_be_kind_of Array
      extracts.must_equal ["http://google.com/about"]
    end

  end # describe

end # describe

