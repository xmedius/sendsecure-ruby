module SendSecure

    class SafeBoxResponse
      attr_accessor :guid,
                    :preview_url,
                    :encryption_key

      def initialize(params)
        @guid = params["guid"]
        @preview_url = params["preview_url"]
        @encryption_key = params["encryption_key"]
      end

    end


end
