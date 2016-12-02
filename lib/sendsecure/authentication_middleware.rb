require 'faraday_middleware'

class XmediusCloudAuthenticationMiddleware < Faraday::Middleware

  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def call(env)
    env[:request_headers]["Authorization-Token"] = @options[:user_token]
    @app.call(env)
  end
end