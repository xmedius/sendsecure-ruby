module SendSecure
  module ClientMethods
    module DocumentMethods

      ###
      # Retrieve a specific file url of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #        document: An Attachment object
      # @return The file url
      ###
      def get_file_url(safebox, document)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        raise SendSecureException.new("SafeBox user email cannot be null") if safebox.user_email == nil
        raise SendSecureException.new("Document GUID cannot be null") if document.guid == nil
        @json_client.get_file_url(safebox.guid, document.guid, safebox.user_email)["url"]
      end

    end
  end
end