module SendSecure


    class ContactMethod < JSONable
      attr_reader   :destination_type, # ["home_phone", "cell_phone", "office_phone", "other_phone"]
                    :destination

    end


end
