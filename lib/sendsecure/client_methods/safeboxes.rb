module SendSecure
  module ClientMethods
    module SafeBoxes

      ###
      # Retrieve a filtered list of safeboxes for the current user account.
      #
      # @param params = { url: <search url>, status: <in_progress, closed, content_deleted or unread>, search_term: <search_term>, per_page: < ]0, 1000] default = 100>, page: <page to return> }
      #           optional filtering parameters
      #
      # @return A Hash containing the count of found safeboxes, previous page url, the next page url and a list of Safebox objects
      ###
      def get_safebox_list(**options)
        result = @json_client.get_safebox_list(options)
        result["safeboxes"] = result["safeboxes"].map {|s| SafeBox.new(s["safebox"]) }
        result
      end

      ###
      # Retrieve a safebox by its guid.
      #
      # @param safebox_guid:
      #                The guid of the safebox to be retrieved
      #
      # @return A SafeBox object
      ###
      def get_safebox(safebox_guid)
        get_safebox_list()["safeboxes"].detect {|safebox| safebox.guid == safebox_guid }
      end

    end
  end
end