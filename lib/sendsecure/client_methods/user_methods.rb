module SendSecure
  module ClientMethods
    module UserMethods

      ###
      # Retrieves all the current user account's settings specific to SendSecure Account
      #
      # @return All values/properties of the user account's settings specific to SendSecure.
      ###
      def user_settings
        UserSetting.new(@json_client.user_setting)
      end

      ###
      # Retrieves all favorites associated to a specific user.
      #
      # @return The list of all favorites of the user account, with all their properties.
      ###
      def favorites
        @json_client.favorites["favorites"].map {|f| Favorite.new(f) }
      end

      ###
      # Create a new favorite associated to a specific user.
      #
      # @param favorite
      #             A Favorite object
      # @return The updated Favorite
      ###
      def create_favorite(favorite)
        raise SendSecureException.new("Favorite email cannot be null") if favorite.email == nil
        favorite.update_attributes(@json_client.create_favorite(favorite.to_json({is_creation: true})))
      end

      ###
      # Edit an existing favorite associated to a specific user.
      #
      # @param favorite
      #             A Favorite object
      # @return The updated Favorite
      ###
      def edit_favorite(favorite)
        raise SendSecureException.new("Favorite id cannot be null") if favorite.id == nil
        favorite.update_attributes(@json_client.edit_favorite(favorite.id, favorite.to_json))
      end

      ###
      # Delete contact methods of an existing favorite associated to a specific user.
      #
      # @param favorite: A Favorite object
      #        contact_method_ids: array of contact method id
      # @return The updated Favorite
      ###
      def delete_favorite_contact_methods(favorite, contact_method_ids)
        raise SendSecureException.new("Favorite id cannot be null") if favorite.id == nil
        favorite.prepare_to_destroy_contact(contact_method_ids)
        favorite.update_attributes(@json_client.edit_favorite(favorite.id, favorite.to_json(destroy_contacts: true)))
      end

      ###
      # Edit an existing favorite associated to a specific user.
      #
      # @param favorite_id:
      #               The id of the favorite to be deleted
      #
      # @return nothing
      ###
      def delete_favorite(favorite_id)
        @json_client.delete_favorite(favorite_id)
      end

    end
  end
end