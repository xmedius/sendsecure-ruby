module SendSecure


    class ExtensionFilter < JSONable
      attr_reader :mode, # ["allow", "forbid"]
                  :list

    end


end
