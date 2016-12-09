module SendSecure

  class Client
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
    def self.get_user_token(enterprise_account, username, password, device_id, device_name, application_type = "SendSecure Ruby", endpoint = "https://portal.xmedius.com", one_time_password = "")
      JsonClient.get_user_token(enterprise_account, username, password, device_id, device_name, application_type, endpoint, one_time_password)
    end

    ###
    # Client object constructor. Used to make call to create a SendSecure
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
      @json_client = JsonClient.new(api_token, enterprise_account, endpoint, locale)
    end

    ###
    # This actually "Sends" the SafeBox with
    # all content and contact info previously specified.
    #
    # @param safebox
    #            A Safebox object already finalized, with security profile, recipient(s), subject and message already
    #            defined, and attachments already uploaded.
    # @return SafeboxResponse
    ###
    def commit_safebox(safebox)
      raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
      raise SendSecureException.new("Recipient cannot be empty") if safebox.recipients.empty?
      raise SendSecureException.new("No Security Profile configured") if safebox.security_profile_id.nil?
      SendSecure::SafeBoxResponse.new(@json_client.commit_safebox(safebox.to_json))
    end

    ###
    # This method is a high-level combo that initializes the SafeBox,
    # uploads all attachments and commits the SafeBox.
    #
    # @param safebox
    #            A non-initialized Safebox object with security profile, recipient(s), subject, message and attachments
    #            (not yet uploaded) already defined.
    # @return SafeboxResponse
    ###
    def submit_safebox(safebox)
      initialize_safebox(safebox)

      safebox.attachments.each do |attachment|
        self.upload_attachment(safebox, attachment)
      end

      if safebox.security_profile_id.nil?
        safebox.security_profile_id = self.enterprise_settings.default_security_profile_id
      end

      commit_safebox(safebox)
    end

    ###
    # Pre-creates a SafeBox on the SendSecure system and initializes the Safebox object accordingly.
    #
    # @param safebox
    #            A SafeBox object to be finalized by the SendSecure system
    # @return The updated SafeBox object with the necessary system parameters (GUID, public encryption key, upload URL)
    # filled out.
    ###
    def initialize_safebox(safebox)
      if safebox.guid.nil?
        result = @json_client.initialize_safebox(safebox.user_email)
        safebox.guid = result["guid"]
        safebox.public_encryption_key = result["public_encryption_key"]
        safebox.upload_url = result["upload_url"]
      end
    end

    ###
    # Uploads the specified file as an Attachment of the specified SafeBox.
    #
    # @param safebox
    #            An initialized Safebox object
    # @param attachment
    #            An Attachment object - the file to upload to the SendSecure system
    # @return The updated Attachment object with the GUID parameter filled out.
    ###
    def upload_attachment(safebox, attachment)
      if attachment.guid.nil?
        result = @json_client.upload_file(safebox.upload_url, attachment.file_path || attachment.file, attachment.content_type, attachment.filename)
        attachment.guid = result["temporary_document"]["document_guid"]
      end
      attachment
    end

    ###
    # Retrieves the default security profile of the enterprise
    # account for a specific user. A default security profile must have been set in the enterprise account, otherwise
    # the method will return nothing.
    #
    # @param user_email
    #            The email address of a SendSecure user of the current enterprise account
    # @return Default security profile of the enterprise, with all its setting values/properties.
    ###
    def default_security_profile(user_email)
      profiles = self.security_profiles(user_email)
      settings = self.enterprise_settings
      profiles.select { |s| s.id == settings.default_security_profile_id }.first
    end

    ###
    # Retrieves all available security profiles of the enterprise account for a specific user.
    #
    # @param user_email
    #            The email address of a SendSecure user of the current enterprise account
    # @return The list of all security profiles of the enterprise account, with all their setting values/properties.
    ###
    def security_profiles(user_email)
      @json_client.security_profiles(user_email)["security_profiles"].map {|s| SecurityProfile.new(s) }
    end

    ###
    # Retrieves all the current enterprise account's settings specific to SendSecure Account
    #
    # @return All values/properties of the enterprise account's settings specific to SendSecure.
    ###
    def enterprise_settings
      EnterpriseSetting.new(@json_client.enterprise_setting)
    end

  end

end

