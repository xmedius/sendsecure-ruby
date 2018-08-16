module SendSecure
  module JsonMethods
    module CreateSafeboxes

      ###
      # Pre-creates a SafeBox on the SendSecure system and initializes the Safebox object accordingly.
      #
      # @param user_email
      #            The email address of a SendSecure user of the current enterprise account
      # @return The json containing the guid, public encryption key and upload url of the initialize SafeBox
      ###
      def initialize_safebox(user_email)
        handle_error { sendsecure_connection.get("/api/v2/safeboxes/new.json", user_email: user_email) }
      end

      ###
      # Pre-creates a document on the SendSecure system and initializes the Safebox object accordingly.
      #
      # @param safebox_guid
      #            The guid of the existing safebox
      # @param file_params
      #            The full json expected by the server
      # @return The json containing the temporary document GUID and the upload URL
      ###
      def initialize_file(safebox_guid, file_params)
        handle_error { sendsecure_connection.post("/api/v2/safeboxes/#{safebox_guid}/uploads", file_params) }
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
      # @param safebox_params
      #            The full json expected by the server
      # @return The json containing the guid, preview url and encryption key of the created SafeBox
      ###
      def commit_safebox(safebox_params)
        handle_error { sendsecure_connection.post("/api/v2/safeboxes.json", safebox_params) }
      end

    end
  end
end