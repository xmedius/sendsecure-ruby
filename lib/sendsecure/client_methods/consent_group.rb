module SendSecure
  module ClientMethods
    module ConsentGroup

      ###
      # Call to get the list of all the localized messages of a consent group.
      #
      # @param consent_group_id:
      #                  The id of the consent group
      #
      # @return The list of all the localized messages
      ###
      def get_consent_group_messages(consent_group_id)
        ConsentMessageGroup.new(@json_client.get_consent_group_messages(consent_group_id)["consent_message_group"])
      end

    end
  end
end