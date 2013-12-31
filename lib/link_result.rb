class LinkResult
  attr_reader :url, :status, :body

  def initialize url, status, body
    @url = url
    @status = status
    @body = body
  end

  def pretty_status
    @status == 900 ? 'Exception' : @status
  end

  def to_s
    "#{pretty_status}: #{@url}"
  end

  def failed?
    @status.to_i >= 400
  end
end
