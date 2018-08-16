module SendSecure
  module JsonMethods
    module ShowSafeboxes

      ###
      # Retrieve a filtered list of safeboxes for the current user account.
      #
      # @param url
      #           The complete search url
      # @param search_params
      #           The optional filtering parameters
      #
      # @return The json containing the count, previous page url, the next page url and a list of Safebox
      ###
      def get_safebox_list(url: nil, search_params: {})
        if url.nil?
          handle_error { sendsecure_connection.get("api/v2/safeboxes.json", search_params) }
        else
          handle_error { sendsecure_connection.get(url) }
        end
      end

      ###
      # Retrieve all info of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #           The guid of the safebox to be updated
      # @param section
      #           The string containing the list of sections to be retrieve
      #
      # @return The json containing complete information on specified sections. If no sections are specified, it will return all safebox info.
      ###
      def get_safebox_info(safebox_guid, sections = nil)
        handle_error { sendsecure_connection.get("api/v2/safeboxes/#{safebox_guid}.json", sections: sections) }
      end

      ###
      # Retrieve all participants info of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #           The guid of the safebox to be updated
      #
      # @return The json containing a list of Participant
      ###
      def get_safebox_participants(safebox_guid)
        handle_error { sendsecure_connection.get("api/v2/safeboxes/#{safebox_guid}/participants.json") }
      end

      ###
      # Retrieve all messages info of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #           The guid of the safebox to be updated
      #
      # @return The json containing a list of Message
      ###
      def get_safebox_messages(safebox_guid)
        handle_error { sendsecure_connection.get("api/v2/safeboxes/#{safebox_guid}/messages.json") }
      end

      ###
      # Retrieve all security options info of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #           The guid of the safebox to be updated
      #
      # @return The json containing the Security Options
      ###
      def get_safebox_security_options(safebox_guid)
        handle_error { sendsecure_connection.get("api/v2/safeboxes/#{safebox_guid}/security_options.json") }
      end

      ###
      # Retrieve all download activity info of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #           The guid of the safebox to be updated
      #
      # @return The json containing the Download Activity
      ###
      def get_safebox_download_activity(safebox_guid)
        handle_error { sendsecure_connection.get("api/v2/safeboxes/#{safebox_guid}/download_activity.json") }
      end

      ###
      # Retrieve all event_history info of an existing safebox for the current user account.
      #
      # @param safebox_guid
      #           The guid of the safebox to be updated
      #
      # @return The json containing a list of EventHistory
      ###
      def get_safebox_event_history(safebox_guid)
        handle_error { sendsecure_connection.get("api/v2/safeboxes/#{safebox_guid}/event_history.json") }
      end

    end
  end
end