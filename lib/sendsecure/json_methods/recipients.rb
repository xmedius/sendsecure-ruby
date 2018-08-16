module SendSecure
  module JsonMethods
    module Recipients

      ###
      # Search the recipients for a safebox
      #
      # @param term
      #          A Search term
      #
      # @return The json containing request result
      ###
      def search_recipient(term)
        handle_error { sendsecure_connection.get("api/v2/participants/autocomplete", term: term) }
      end

    end
  end
end