module SendSecure


    class ContactMethod < JSONable
      attr_reader   :destination_type, # ["home_phone", "cell_phone", "office_phone", "other_phone"]
                    :destination

      def destination_type
        @destination_type || "cell_phone"
      end
    end


end
