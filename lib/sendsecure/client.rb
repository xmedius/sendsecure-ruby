module SendSecure

  class Client
    include ClientMethods::CreateSafeboxes
    include ClientMethods::SafeBoxes
    include ClientMethods::DocumentMethods
    include ClientMethods::ParticipantMethods
    include ClientMethods::SafeboxMethods
    include ClientMethods::UserMethods
    include ClientMethods::EnterpriseMethods
    include ClientMethods::Recipients
    include ClientMethods::ConsentGroup

    attr_reader :json_client

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
      JsonClient.get_user_token(options.merge({ application_type: application_type, endpoint: endpoint, one_time_password: one_time_password }))
    end

    ###
    # Client object constructor. Used to make call to create a SendSecure
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
      @json_client = JsonClient.new(endpoint: endpoint, locale: locale, **options)
    end

  end

end

