module SendSecure
  module ClientMethods
    module ParticipantMethods

      ###
      # Create a new participant for a specific safebox associated to the current user's account,
      #     and add the new participant to the Safebox object.
      #
      # @param safebox: A Safebox object
      #        participant: A Participant object
      # @return The updated Participant
      ###
      def create_participant(safebox, participant)
        raise SendSecureException.new("Participant email cannot be null") if participant.email == nil
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        participant.update_attributes(@json_client.create_participant(safebox.guid, participant.to_json({is_creation: true})))
        safebox.participants << participant
        participant
      end

      ###
      # Update an existing participant of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #        participant: A Participant object
      # @return The updated Participant
      ###
      def update_participant(safebox, participant)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        raise SendSecureException.new("Participant id cannot be null") if participant.id == nil
        participant.update_attributes(@json_client.update_participant(safebox.guid, participant.id, participant.to_json))
      end

      ###
      # Delete contact methods of an existing participant of a specific safebox associated to the current user's account.
      #
      # @param safebox: A Safebox object
      #        participant: A Participant object
      #        contact_method_ids: array of contact method id
      # @return The updated Participant
      ###
      def delete_participant_contact_methods(safebox, participant, contact_method_ids)
        raise SendSecureException.new("SafeBox GUID cannot be null") if safebox.guid == nil
        raise SendSecureException.new("Participant id cannot be null") if participant.id == nil
        participant.prepare_to_destroy_contact(contact_method_ids)
        participant.update_attributes(@json_client.update_participant(safebox.guid, participant.id, participant.to_json(destroy_contacts: true)))
      end

    end
  end
end