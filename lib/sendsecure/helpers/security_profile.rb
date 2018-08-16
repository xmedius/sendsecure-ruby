module SendSecure
  class SecurityProfile < JSONable

    attr_reader   :id,
                  :name,
                  :description,
                  :created_at,
                  :updated_at,
                  :allowed_login_attempts,  # Value
                  :allow_remember_me,       # Value
                  :allow_sms,               # Value
                  :allow_voice,             # Value
                  :allow_email,             # Value
                  :code_time_limit,         # Value
                  :code_length,             # Value
                  :auto_extend_value,       # Value
                  :auto_extend_unit,        # Value
                  :two_factor_required,     # Value
                  :encrypt_attachments,     # Value
                  :encrypt_message,         # Value
                  :expiration_value,        # Value
                  :expiration_unit,         # Value
                  :reply_enabled,           # Value
                  :group_replies,           # Value
                  :double_encryption,       # Value
                  :retention_period_type,   # Value
                  :retention_period_value,  # Value
                  :retention_period_unit,   # Value
                  :allow_manual_delete,     # Value
                  :allow_manual_close,      # Value
                  :allow_for_secure_links,  # Value
                  :use_captcha,             # Value
                  :verify_email,            # Value
                  :distribute_key,          # Value
                  :consent_group_id         # Value

    def to_object(name, value)
      if ![:id, :name, :description, :created_at, :updated_at].include?(name)
        return Value.new(value)
      else
        return nil
      end
    end

  end
end
