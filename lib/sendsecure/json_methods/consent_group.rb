module SendSecure
  module JsonMethods
    module ConsentGroup

      ###
      # Call to get the list of all the localized messages of a consent group.
      #
      # @param consent_group_id:
      #                  The id of the consent group
      #
      # @return The json containing the list of all the localized messages
      ###
      def get_consent_group_messages(consent_group_id)
        handle_error { sendsecure_connection.get("api/v2/enterprises/#{@enterprise_account}/consent_message_groups/#{consent_group_id}") }
      end

    end
  end
end
