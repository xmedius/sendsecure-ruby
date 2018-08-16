module SendSecure
  module JsonMethods
    module UserMethods

      ###
      # Get the User Settings of the current user account
      #
      # @return The json containing the user settings
      ###
      def user_setting
        handle_error { sendsecure_connection.get("api/v2/enterprises/#{@enterprise_account}/users/#{@user_id}/settings.json") }
      end

      ###
      # Retrieves all favorites for the current user account.
      #
      # @return The json containing a list of Favorite
      ###
      def favorites
        handle_error { sendsecure_connection.get("api/v2/enterprises/#{@enterprise_account}/users/#{@user_id}/favorites.json") }
      end

      ###
      # Create a new favorite for the current user account.
      #
      # @param favorite_params
      #            The full json expected by the server
      # @return The json containing all information on Favorite
      ###
      def create_favorite(favorite_params)
        handle_error { sendsecure_connection.post("api/v2/enterprises/#{@enterprise_account}/users/#{@user_id}/favorites.json", favorite_params) }
      end

      ###
      # Edit an existing favorite for the current user account.
      #
      # @param favorite_id
      #            The id of the favorite to be updated
      # @param favorite_params
      #            The full json expected by the server
      #
      # @return The json containing all information of the updated Favorite
      ###
      def edit_favorite(favorite_id, favorite_params)
        handle_error { sendsecure_connection.patch("api/v2/enterprises/#{@enterprise_account}/users/#{@user_id}/favorites/#{favorite_id}.json", favorite_params) }
      end

      ###
      # Delete an existing favorite for the current user account.
      #
      # @param favorite_id
      #            The id of the favorite to be deleted
      #
      # @return Nothing
      ###
      def delete_favorite(favorite_id)
        handle_error { sendsecure_connection.delete("api/v2/enterprises/#{@enterprise_account}/users/#{@user_id}/favorites/#{favorite_id}.json") }
      end

    end
  end
end