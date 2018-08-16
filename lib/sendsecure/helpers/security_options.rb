module SendSecure
  class SecurityOptions < JSONable

    attr_accessor :reply_enabled,
                  :group_replies,
                  :retention_period_type, # [:discard_at_expiration, :retain_at_expiration, :do_not_discard]
                  :retention_period_value,
                  :retention_period_unit,
                  :encrypt_message,
                  :double_encryption,
                  :expiration_value,
                  :expiration_unit,
                  :expiration_date,
                  :expiration_time,
                  :expiration_time_zone


    attr_reader   :security_code_length,
                  :code_time_limit,
                  :allowed_login_attempts,
                  :allow_remember_me,
                  :allow_sms,
                  :allow_voice,
                  :allow_email,
                  :two_factor_required,
                  :auto_extend_value,
                  :auto_extend_unit,
                  :allow_manual_delete,
                  :allow_manual_close,
                  :encrypt_attachments,
                  :consent_group_id

    def hashable_keys(params)
      keys = [ "reply_enabled", "group_replies", "retention_period_type",
               "retention_period_value", "retention_period_unit", "encrypt_message",
               "double_encryption", "expiration_value", "expiration_unit" ]
      keys << "expiration_date" << "expiration_time" << "expiration_time_zone" unless expiration_date.nil?
      keys
    end
  end
end