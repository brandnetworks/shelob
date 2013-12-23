class LinkResult
  attr_reader :url, :status, :body

  def initialize url, status, body
    @url = url
    @status = status
    @body = body
  end

  def to_s
    "#{@status}: #{@url}"
  end
end
