module TestUtils

  def sendsecure_connection
    @connection ||= Faraday.new do |builder|
      builder.response :json

      builder.adapter :test do |stubs|
        yield(stubs)
      end
    end
  end

end
