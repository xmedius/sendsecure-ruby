module SendSecure


    class SecurityProfile < JSONable
      attr_reader   :id,
                    :name,
                    :description,
                    :created_at,
                    :updated_at,
                    :allowed_login_attempts, # Value
                    :allow_remember_me, # Value
                    :allow_sms, # Value
                    :allow_voice, # Value
                    :allow_email, # Value
                    :code_time_limit, # Value
                    :code_length, # Value
                    :auto_extend_value, # Value
                    :auto_extend_unit, # Value
                    :two_factor_required, # Value
                    :encrypt_attachments, # Value
                    :encrypt_message, # Value
                    :expiration_value, # Value
                    :expiration_unit, # Value
                    :reply_enabled, # Value
                    :group_replies, # Value
                    :double_encryption, # Value
                    :retention_period_type, # Value
                    :retention_period_value, # Value
                    :retention_period_unit # Value

      def initialize(params)
        params.each do |key, value|
          if !["id", "name", "description", "created_at", "updated_at"].include?(key)
            instance_variable_set("@#{key}", Value.new(value))
          else
            instance_variable_set("@#{key}", value)
          end
        end
      end

    end


end
