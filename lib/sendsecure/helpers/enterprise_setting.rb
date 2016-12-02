module SendSecure


    class EnterpriseSetting < JSONable
      attr_reader   :created_at,
                    :updated_at,
                    :default_security_profile_id,
                    :pdf_language,
                    :use_pdfa_audit_records,
                    :international_dialing_plan,
                    :extension_filter, # see ExtensionFilter
                    :include_users_in_autocomplete,
                    :include_favorites_in_autocomplete

      def initialize(params)
        params.each do |key, value|
          if key == :extension_filter
            instance_variable_set("@#{key}", ExtensionFilter.new(value))
          else
            instance_variable_set("@#{key}", value)
          end
        end
      end

    end


end