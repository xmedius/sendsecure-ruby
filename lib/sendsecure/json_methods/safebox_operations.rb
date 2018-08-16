module SendSecure
  module JsonMethods
    module SafeboxOperations

      ###
      # Reply to a specific safebox associated to the current user's account.
      #
      # @param safebox_guid
      #            The guid of the safebox to be updated
      # @param reply_params
      #            The full json expected by the server
      #
      # @return The json containing request result
      ###
      def reply(safebox_guid, reply_params)
        handle_error { sendsecure_connection.post("api/v2/safeboxes/#{safebox_guid}/messages.json", reply_params) }
      end

      ###
      # Create a new participant for a specific open safebox of the current user account.
      #
      # @param safebox_guid
      #            The guid of the safebox to be updated
      # @param participant_params
      #            The full json expected by the server

      # @return The json containing all information on new Participant
      ###
      def create_participant(safebox_guid, participant_params)
        handle_error { sendsecure_connection.post("api/v2/safeboxes/#{safebox_guid}/participants.json", participant_params) }
      end

      ###
      # Edit an existing participant for a specific open safebox of the current user account.
      #
      # @param safebox_guid
      #            The guid of the safebox to be updated
      # @param participant_guid
      #            The guid of the participant to be updated
      # @param participant_params
      #            The full json expected by the server
      #
      # @return The json containing all information on Participant
      ###
      def update_participant(safebox_guid, participant_guid, participant_params)
        handle_error { sendsecure_connection.patch("api/v2/safeboxes/#{safebox_guid}/participants/#{participant_guid}.json", participant_params) }
      end

      ###
      # Manually add time to expiration date for a specific open safebox of the current user account.
      #
      # @param safebox_guid
      #            The guid of the participant to be updated
      # @param add_time_params
      #            The full json expected by the server
      #
      # @return The json containing request result and new expiration date
      ###
      def add_time(safebox_guid, add_time_params)
        handle_error { sendsecure_connection.patch("api/v2/safeboxes/#{safebox_guid}/add_time.json", add_time_params) }
      end

      ###
      # Manually close an existing safebox for the current user account.
      #
      # @param safebox_guid
      #
      # @return The json containing request result
      ###
      def close_safebox(safebox_guid)
        handle_error { sendsecure_connection.patch("api/v2/safeboxes/#{safebox_guid}/close.json") }
      end

      ###
      # Manually delete the content of a closed safebox for the current user account.
      #
      # @param safebox_guid
      #
      # @return The json containing request result
      ###
      def delete_safebox_content(safebox_guid)
        handle_error { sendsecure_connection.patch("api/v2/safeboxes/#{safebox_guid}/delete_content.json") }
      end

      ###
      # Manually mark as read an existing safebox for the current user account.
      #
      # @param safebox_guid
      #
      # @return The json containing request result
      ###
      def mark_as_read(safebox_guid)
        handle_error { sendsecure_connection.patch("api/v2/safeboxes/#{safebox_guid}/mark_as_read.json") }
      end

      ###
      # Manually mark as unread an existing safebox for the current user account.
      #
      # @param safebox_guid
      #
      # @return The json containing request result
      ###
      def mark_as_unread(safebox_guid)
        handle_error { sendsecure_connection.patch("api/v2/safeboxes/#{safebox_guid}/mark_as_unread.json") }
      end

      ###
      # Manually mark as read an existing message.
      #
      # @param safebox_guid
      #
      # @param message_id
      #
      # @return The json containing request result
      ###
      def mark_as_read_message(safebox_guid, message_id)
        handle_error { sendsecure_connection.patch("api/v2/safeboxes/#{safebox_guid}/messages/#{message_id}/read") }
      end

      ###
      # Manually mark as unread an existing message.
      #
      # @param safebox_guid
      #
      # @param message_id
      #
      # @return The json containing request result
      ###
      def mark_as_unread_message(safebox_guid, message_id)
        handle_error { sendsecure_connection.patch("api/v2/safeboxes/#{safebox_guid}/messages/#{message_id}/unread") }
      end

      ###
      # Retrieve a specific file url of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #            The guid of the safebox to be updated
      # @param document_guid
      #            The guid of the file
      # @param user_email
      #            The current user email
      #
      # @return The json containing the file url on the fileserver
      ###
      def get_file_url(safebox_guid, document_guid, user_email)
        handle_error { sendsecure_connection.get("api/v2/safeboxes/#{safebox_guid}/documents/#{document_guid}/url.json", user_email: user_email) }
      end

      ###
      # Retrieve the url of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #
      # @return The json containing the pdf url
      ###
      def get_audit_record_pdf_url(safebox_guid)
        handle_error { sendsecure_connection.get("api/v2/safeboxes/#{safebox_guid}/audit_record_pdf.json") }
      end

      ###
      # Retrieve the pdf of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #
      # @return The audit record pdf
      ###
      def get_audit_record_pdf(url)
        handle_error { Faraday.get(url) }
      end

    end
  end
end