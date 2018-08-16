module SendSecure
  module ClientMethods
    module CreateSafeboxes

      ###
      # This method is a high-level combo that initializes the SafeBox,
      # uploads all attachments and commits the SafeBox.
      #
      # @param safebox
      #            A non-initialized Safebox object with security profile, recipient(s), subject, message and attachments
      #            (not yet uploaded) already defined.
      # @return Updated Safebox
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
      # This actually "Sends" the SafeBox with
      # all content and contact info previously specified.
      #
      # @param safebox
      #            A Safebox object already finalized, with security profile, recipient(s), subject and message already
      #            defined, and attachments already uploaded.
      # @return Updated Safebox
      ###
      def commit_safebox(safebox)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        raise SendSecureException.new("Recipient cannot be empty") if safebox.participants.empty?
        raise SendSecureException.new("No Security Profile configured") if safebox.security_profile_id.nil?
        safebox.update_attributes(@json_client.commit_safebox(safebox.to_json).merge({is_creation: true}))
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
        result = @json_client.initialize_safebox(safebox.user_email)
        safebox.guid = result["guid"]
        safebox.public_encryption_key = result["public_encryption_key"]
        safebox.upload_url = result["upload_url"]
      end

      ###
      # Pre-creates a SafeBox on the SendSecure system and initializes the Safebox object accordingly.
      #
      # @param safebox
      #            A SafeBox object to be finalized by the SendSecure system
      # @return The updated SafeBox object with the necessary system parameters (GUID, public encryption key, upload URL)
      # filled out. Raise SendSecureException if the safebox is already initialize.
      ###
      def initialize_safebox!(safebox)
        raise SendSecureException.new("SafeBox was already initialized") unless safebox.guid.nil?
        initialize_safebox(safebox)
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

    end
  end
end