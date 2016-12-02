 module SendSecure
  require 'faraday'
  require 'json'

  class JsonClient
    @locale
    @enterprise_account
    @endpoint
    @sendsecure_endpoint
    @api_token


    def initialize(api_token, enterprise_account, endpoint = "https://portal.xmedius.com", locale = "en")
      @locale = locale
      @enterprise_account = enterprise_account
      @endpoint = endpoint
      @api_token = api_token
      @sendsecure_endpoint = get_sendsecure_endpoint
    end

    # GET
    def self.get_user_token(enterprise_account, username, password, endpoint = "https://portal.xmedius.com", one_time_password = "")
      begin
        response = Faraday.post("#{endpoint}/api/user_token", permalink: enterprise_account, username: username, password: password,
                      otp: one_time_password, application_type: "Sendsecure Ruby", device_id: "device_id", device_name: "systemtest")
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

    # GET
    def new_safebox(user_email)
      handle_error { sendsecure_connection.get("api/v2/safeboxes/new?user_email=#{user_email}&locale=#{@locale}") }
    end

    # POST
    def upload_file(upload_url, filename_or_io, content_type, filename = nil)
      fileserver_connection = handle_connection_error do
        Faraday.new(url: upload_url) do |conn|
          conn.request :multipart
          conn.response :json, content_type: /\bjson$/
          conn.adapter Faraday.default_adapter
        end
      end
      handle_error do
        fileserver_connection.post do |req|
          req.body = { file: UploadIO.new(filename_or_io, content_type, filename) }
        end
      end
    end

    # POST
    def commit_safebox(safebox_json)
      handle_error { sendsecure_connection.post("/api/v2/safeboxes", safebox_json) }
    end

    # GET
    def security_profiles(user_email)
      handle_error { sendsecure_connection.get("api/v2/enterprises/#{@enterprise_account}/security_profiles?user_email=#{user_email}&locale=#{@locale}") }
    end

    # GET
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
