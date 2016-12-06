module SendSecure


    class Recipient < JSONable
      attr_reader   :first_name,
                    :last_name,
                    :company_name,
                    :email,
                    :contact_methods # List of ContactMethods

      def initialize(params)
        params.each do |key, value|
          if key == :contact_methods
            instance_variable_set("@#{key}", value.map { |c| ContactMethod.new(c) })
          else
            instance_variable_set("@#{key}", value)
          end
        end
      end

      def contact_methods
        @contact_methods ||= []
      end

    end


end
