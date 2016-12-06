module SendSecure

  class Client
    attr_reader :json_client

    # Class method used to authenticate the user
    # enterprise_account: permalink of the enterprise
    # endpoint: the host of the portal (.com ou .eu), defaults to .com
    def self.get_user_token(enterprise_account, username, password, device_id, device_name, application_type = "sendsecure-ruby", endpoint = "https://portal.xmedius.com", one_time_password = "")
      JsonClient.get_user_token(enterprise_account, username, password, device_id, device_name, application_type, endpoint, one_time_password)
    end

    # enterprise_account: permalink of the enterprise
    # api_token:  can be either a user token or a access token (access token not yet implemented!)
    def initialize(api_token, enterprise_account, endpoint = "https://portal.xmedius.com", locale = "en")
      @json_client = JsonClient.new(api_token, enterprise_account, endpoint, locale)
    end

    # Finalize the safebox if needed and commit it
    # safebox: Safebox object
    def commit_safebox(safebox)
      finalize_safebox(safebox) if (safebox.guid.nil? || safebox.security_profile_id.nil? || safebox.attachments.select { |a| a.guid.nil? }.size > 0)
      @json_client.commit_safebox(safebox.to_json)
    end

    # Get a guid, public_encryption_key and upload URL for the safebox,
    # upload the attachments, and assign a default security profile
    # safebox: Safebox object
    def finalize_safebox(safebox)
      if safebox.guid.nil?
        result = @json_client.new_safebox(safebox.user_email)
        safebox.guid = result["guid"]
        safebox.public_encryption_key = result["public_encryption_key"]
        safebox.upload_url = result["upload_url"]
      end

      safebox.attachments.each do |attachment|
        self.upload_attachment(safebox, attachment)
      end

      if safebox.security_profile_id.nil?
        safebox.security_profile_id = self.enterprise_settings.default_security_profile_id
        raise SendSecureException.new("No Security Profile configured") if safebox.security_profile_id.nil?
      end
    end

    # Create a new SafeBox with a guid, public_encryption_key and upload URL
    def new_safebox(user_email)
      SendSecure::SafeBox.new(@json_client.new_safebox(user_email))
    end

    # Get a guid for the attachment
    # safebox: Safebox object
    # attachment: Attachment object
    # returns: Attachment object (with its created guid)
    def upload_attachment(safebox, attachment)
      if attachment.guid.nil?
        result = @json_client.upload_file(safebox.upload_url, attachment.file_path || attachment.file, attachment.content_type, attachment.filename)
        attachment.guid = result["temporary_document"]["document_guid"]
      end
      attachment
    end

    #return a SecurityProfile
    def default_security_profile(user_email)
      self.security_profiles(user_email).select { |s| s.id == self.enterprise_settings.default_security_profile_id }.first
    end

    # return list of SecurityProfile
    def security_profiles(user_email)
      @json_client.security_profiles(user_email)["security_profiles"].map {|s| SecurityProfile.new(s) }
    end

    #return EnterpriseSetting
    def enterprise_settings
      EnterpriseSetting.new(@json_client.enterprise_setting)
    end

  end

end

