 module SendSecure
  require 'faraday'
  require 'json'

  class JsonClient
    @locale
    @enterprise_account
    @endpoint
    @sendsecure_endpoint
    @api_token

    ###
    # JsonClient object constructor. Used to make call to create a SendSecure
    #
    # @param api_token
    #            The API Token to be used for authentication with the SendSecure service
    # @param enterprise_account
    #            The SendSecure enterprise account
    # @param endpoint
    #            The URL to the SendSecure service ("https://portal.xmedius.com" will be used by default if empty)
    # @param locale
    #            The locale in which the server errors will be returned ("en" will be used by default if empty)
    ###
    def initialize(api_token, enterprise_account, endpoint = "https://portal.xmedius.com", locale = "en")
      @locale = locale
      @enterprise_account = enterprise_account
      @endpoint = endpoint
      @api_token = api_token
      @sendsecure_endpoint = get_sendsecure_endpoint
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
    def self.get_user_token(enterprise_account, username, password, device_id, device_name, application_type = "SendSecure Ruby", endpoint = "https://portal.xmedius.com", one_time_password = "")
      begin
        response = Faraday.post("#{endpoint}/api/user_token", permalink: enterprise_account, username: username, password: password,
                      otp: one_time_password, application_type: application_type, device_id: device_id, device_name: device_name)
      rescue Faraday::Error::ResourceNotFound
        raise SendSecureException.new("not found", "404")
      rescue Faraday::Error => e
        raise SendSecureException.new(e.message, "500")
      end

      begin
        parsed_response = JSON.parse(response.body)
        raise SendSecureException.new(parsed_response["message"], parsed_response["code"]) unless parsed_response["result"] == true
        return parsed_response["token"]
      rescue JSON::ParserError, TypeError
        raise UnexpectedServerResponseException
      end
    end

    ###
    # Pre-creates a SafeBox on the SendSecure system and initializes the Safebox object accordingly.
    #
    # @param user_email
    #            The email address of a SendSecure user of the current enterprise account
    # @return The json containing the guid, public encryption key and upload url of the initialize SafeBox
    ###
    def initialize_safebox(user_email)
      handle_error { sendsecure_connection.get("api/v2/safeboxes/new?user_email=#{user_email}&locale=#{@locale}") }
    end

    ###
    # Uploads the specified file as an Attachment of the specified SafeBox.
    #
    # @param upload_url
    #            The url returned by the initializeSafeBox. Can be used multiple time
    # @param filename_or_stream
    #            The path of the file to upload or the stream
    # @param content_type
    #            The MIME content type of the uploaded file
    # @return The json containing the guid of the uploaded file
    ###
    def upload_file(upload_url, filename_or_stream, content_type, filename = nil)
      handle_error do
        fileserver_connection(upload_url).post do |req|
          req.body = { file: UploadIO.new(filename_or_stream, content_type, filename) }
        end
      end
    end

    ###
    # Finalizes the creation (commit) of the SafeBox on the SendSecure system. This actually "Sends" the SafeBox with
    # all content and contact info previously specified.
    #
    # @param safebox_json
    #            The full json expected by the server
    # @return The json containing the guid, preview url and encryption key of the created SafeBox
    ###
    def commit_safebox(safebox_json)
      handle_error { sendsecure_connection.post("/api/v2/safeboxes", safebox_json) }
    end

    ###
    # Retrieves all available security profiles of the enterprise account for a specific user.
    #
    # @param user_email
    #            The email address of a SendSecure user of the current enterprise account
    # @return The json containing a list of Security Profile
    ###
    def security_profiles(user_email)
      handle_error { sendsecure_connection.get("api/v2/enterprises/#{@enterprise_account}/security_profiles?user_email=#{user_email}&locale=#{@locale}") }
    end

    ###
    # Get the Enterprise Settings of the current enterprise account
    #
    # @return The json containing the enterprise settings
    ###
    def enterprise_setting()
      handle_error { sendsecure_connection.get("api/v2/enterprises/#{@enterprise_account}/settings?locale=#{@locale}") }
    end

  private

    def get_sendsecure_endpoint
      handle_error { Faraday.get("#{@endpoint}/services/#{@enterprise_account}/sendsecure/server/url") }
    end

    def sendsecure_connection
      @sendsecure_connection ||= handle_connection_error do
        Faraday.new(url: @sendsecure_endpoint) do |conn|
          conn.use XmediusCloudAuthenticationMiddleware, user_token: @api_token
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
        if response.status == 200
          response.body
        elsif response.body.is_a?(Hash)
          raise SendSecureException.new(response.body["message"] || [response.body["error"], response.body["attributes"]].join(" "), response.status)
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
