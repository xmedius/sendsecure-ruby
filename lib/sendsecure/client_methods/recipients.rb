module SendSecure
  module ClientMethods
    module Recipients

      ###
      # Search the recipients for a SafeBox
      #
      # @param term: A Search term
      #
      # @return The list of recipients that matches the search term
      ###
      def search_recipient(term)
        raise SendSecureException.new("Search term cannot be null") if term.nil?
        @json_client.search_recipient(term)
      end

    end
  end
end