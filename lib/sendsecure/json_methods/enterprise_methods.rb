module SendSecure
  module JsonMethods
    module EnterpriseMethods

      ###
      # Retrieves all available security profiles of the enterprise account for a specific user.
      #
      # @param user_email
      #            The email address of a SendSecure user of the current enterprise account
      # @return The json containing a list of Security Profile
      ###
      def security_profiles(user_email)
        handle_error { sendsecure_connection.get("api/v2/enterprises/#{@enterprise_account}/security_profiles.json", user_email: user_email) }
      end

      ###
      # Get the Enterprise Settings of the current enterprise account
      #
      # @return The json containing the enterprise settings
      ###
      def enterprise_setting
        handle_error { sendsecure_connection.get("api/v2/enterprises/#{@enterprise_account}/settings.json") }
      end

    end
  end
end