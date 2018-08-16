module SendSecure
  require 'faraday'
  require 'json'

  class JsonClient
    include JsonMethods::CreateSafeboxes
    include JsonMethods::ShowSafeboxes
    include JsonMethods::SafeboxOperations
    include JsonMethods::UserMethods
    include JsonMethods::EnterpriseMethods
    include JsonMethods::Recipients
    include JsonMethods::ConsentGroup

    @locale
    @enterprise_account
    @endpoint
    @sendsecure_endpoint
    @api_token
    @user_id

    ###
    # JsonClient object constructor. Used to make call to create a SendSecure
    #
    # @param api_token
    #            The API Token to be used for authentication with the SendSecure service
    # @param user_id
    #            The user id of the current user
    # @param enterprise_account
    #            The SendSecure enterprise account
    # @param endpoint
    #            The URL to the SendSecure service ("https://portal.xmedius.com" will be used by default if empty)
    # @param locale
    #            The locale in which the server errors will be returned ("en" will be used by default if empty)
    ###
    def initialize(endpoint: "https://portal.xmedius.com", locale: "en", **options)
      raise SendSecureException.new("API Token must be provided") if options[:api_token] == nil
      @locale = locale
      @enterprise_account = options[:enterprise_account]
      @endpoint = endpoint
      @api_token = options[:api_token]
      @sendsecure_endpoint = get_sendsecure_endpoint
      @user_id = options[:user_id]
    end

    ###
    # Gets an API Token for a specific user within a SendSecure enterprise account.
    #
    # @param enterprise_account
    #            The SendSecure enterprise account
    # @param username
    #            The username of a SendSecure user of the current enterprise account
    # @param password
    #            The password of this user
    # @param device_id
    #            The unique ID of the device used to get the Token
    # @param device_name
    #            The name of the device used to get the Token
    # @param application_type
    #            The type/name of the application used to get the Token ("SendSecure Ruby" will be used by default if empty)
    # @param otp
    #            The one-time password of this user (if any)
    # @param endpoint
    #            The URL to the SendSecure service ("https://portal.xmedius.com" will be used by default if empty)
    # @return API Token to be used for the specified user
    ###
    def self.get_user_token(application_type: "SendSecure Ruby", endpoint: "https://portal.xmedius.com", one_time_password: "", **options)
      begin
        response = Faraday.post("#{endpoint}/api/user_token", permalink: options[:enterprise_account], username: options[:username], password: options[:password],
                      otp: one_time_password, application_type: application_type, device_id: options[:device_id], device_name: options[:device_name])
      rescue Faraday::Error::ResourceNotFound
        raise SendSecureException.new("not found", "404")
      rescue Faraday::Error => e
        raise SendSecureException.new(e.message, "500")
      end

      begin
        parsed_response = JSON.parse(response.body)
        raise SendSecureException.new(parsed_response["message"], parsed_response["code"]) unless parsed_response["result"] == true
        return parsed_response
      rescue JSON::ParserError, TypeError
        raise UnexpectedServerResponseException
      end
    end

  private

    def get_sendsecure_endpoint
      handle_error { Faraday.get("#{@endpoint}/services/#{@enterprise_account}/sendsecure/server/url") }
    end

    def sendsecure_connection
      @sendsecure_connection ||= handle_connection_error do
        Faraday.new(url: @sendsecure_endpoint) do |conn|
          conn.use XmediusCloudAuthenticationMiddleware, user_token: @api_token
          conn.use XmediusCloudRequestMiddleware, locale: @locale
          conn.use FaradayMiddleware::FollowRedirects
          conn.request :json
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
        end
      end
    end

    def fileserver_connection(upload_url)
      Faraday.new(url: upload_url) do |conn|
        conn.request :multipart
        conn.response :json, content_type: /\bjson$/
        conn.adapter Faraday.default_adapter
      end
    end

    def handle_error
      handle_connection_error do
        response = yield
        if response.status >= 200 && response.status <= 299
          response.body
        elsif response.body.is_a?(Hash)
          raise SendSecureException.new([response.body["error"], response.body["attributes"]].join(" "), response.status) if response.body["attributes"]
          raise SendSecureException.new(response.body["message"] || response.body["error"], response.status)
        else
          begin
            parsed_response = JSON.parse(response.body)
            raise SendSecureException.new(parsed_response["message"], parsed_response["code"] || response.status)
          rescue JSON::ParserError, TypeError
            raise UnexpectedServerResponseException
          end
        end
      end
    end

    def handle_connection_error
      begin
        yield
      rescue Faraday::Error::ResourceNotFound
        raise SendSecureException.new("not found", "404")
      rescue Faraday::Error => e
        raise SendSecureException.new(e.message, "500")
      end
    end

  end

end