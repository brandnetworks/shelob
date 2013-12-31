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

  def failed?
    @status.to_i >= 400
  end
end
