require 'faraday_middleware'

class XmediusCloudRequestMiddleware < Faraday::Middleware

  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def call(env)
    query_params = env[:url].query.nil? ? [] : URI.decode_www_form(env[:url].query)
    args_with_locale = query_params << ["locale", @options[:locale]]
    env[:url].query = URI.encode_www_form(args_with_locale)
    @app.call(env)
  end
end
