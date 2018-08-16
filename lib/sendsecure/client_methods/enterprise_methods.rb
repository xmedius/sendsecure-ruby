module SendSecure
  module ClientMethods
    module EnterpriseMethods

      ###
      # Retrieves the default security profile of the enterprise
      # account for a specific user. A default security profile must have been set in the enterprise account, otherwise
      # the method will return nothing.
      #
      # @param user_email
      #            The email address of a SendSecure user of the current enterprise account
      # @return Default security profile of the enterprise, with all its setting values/properties.
      ###
      def default_security_profile(user_email)
        profiles = self.security_profiles(user_email)
        settings = self.enterprise_settings
        profiles.find { |s| s.id == settings.default_security_profile_id }
      end

      ###
      # Retrieves all available security profiles of the enterprise account for a specific user.
      #
      # @param user_email
      #            The email address of a SendSecure user of the current enterprise account
      # @return The list of all security profiles of the enterprise account, with all their setting values/properties.
      ###
      def security_profiles(user_email)
        @json_client.security_profiles(user_email)["security_profiles"].map {|s| SecurityProfile.new(s) }
      end

      ###
      # Retrieves all the current enterprise account's settings specific to SendSecure Account
      #
      # @return All values/properties of the enterprise account's settings specific to SendSecure.
      ###
      def enterprise_settings
        EnterpriseSetting.new(@json_client.enterprise_setting)
      end

    end
  end
end