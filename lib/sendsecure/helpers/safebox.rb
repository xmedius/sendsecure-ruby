module SendSecure
  class SafeBox < JSONable

    attr_accessor :guid,
                  :public_encryption_key,
                  :upload_url,
                  :user_email,
                  :participants, # List of Participants
                  :subject,
                  :message,
                  :attachments, # List of Attachments -> document_ids
                  :notification_language,
                  :security_profile_id,
                  :email_notification_enabled,
                  :expiration

    attr_reader   :user_id,
                  :enterprise_id,
                  :status, #[:in_progress, :closed, :content_deleted]
                  :security_profile_name,
                  :unread_count,
                  :double_encryption_status,
                  :audit_record_pdf,
                  :secure_link,
                  :secure_link_title,
                  :preview_url,
                  :encryption_key,
                  :created_at,
                  :updated_at,
                  :assigned_at,
                  :latest_activity,
                  :closed_at,
                  :content_deleted_at,
                  :security_options, # See SecurityOption
                  :messages, # List of Messages
                  :download_activity, #See DownloadActivity
                  :event_history # List of EventHistory

    TIME_UNIT = { hours: 'hours', days: 'days', weeks: 'weeks', months: 'months' }
    LONG_TIME_UNIT = { hours: 'hours', days: 'days', weeks: 'weeks', months: 'months', years: 'years' }

    def update_attributes(params)
      if params[:is_creation]
        params.delete(:is_creation)
        params[:security_options] = {}
        security_options_key.each do |key|
          if params.include?(key)
            value = params.delete(key)
            params[:security_options][key] = value
          end
        end
      end
      super(params)
    end

    def expiration_values=(date_time)
      raise SendSecureException.new("Cannot change the expiration of a committed safebox, please see the method add_time to extend the lifetime of the safebox") unless self.status.nil?
      update_attributes({ "security_options":{
                            "expiration_date": date_time.strftime("%Y-%m-%d"),
                            "expiration_time": date_time.strftime("%H:%M:%S"),
                            "expiration_time_zone": date_time.zone }})
    end

    def attachments
      @attachments ||= []
    end

    def participants
      @participants ||= []
    end

    def messages
      @messages ||= []
    end

    def event_history
      @event_history ||= []
    end

    def to_hash(params = {})
      hash = super(params)
      hash["document_ids"] = document_ids
      hash["recipients"] = self.participants.map { |p| p.to_hash(params) }
      self.security_options.nil? ? hash : hash.merge(self.security_options.to_hash(params))
    end

    def document_ids
      self.attachments.map { |a| a.guid }
    end

    def temporary_document(file_size)
      self.public_encryption_key.nil? ?
          file_params = { "temporary_document":
                            { "document_file_size": file_size },
                          "multipart": false
                        }
          :
          file_params = { "temporary_document":
                            { "document_file_size": file_size },
                          "multipart": false,
                          "public_encryption_key": self.public_encryption_key
                        }
    end

    def hashable_keys(params)
      [ "guid", "subject", "message",
        "security_profile_id", "public_encryption_key",
        "notification_language", "user_email", "email_notification_enabled" ]
    end

    def to_object(name, value)
      case name
        when :security_options
          return SecurityOptions.new(value)
        when :participants
          return Participant.new(value)
        when :messages
          return Message.new(value)
        when :download_activity
          return DownloadActivity.new(value)
        when :event_history
          return EventHistory.new(value)
        when :attachments
          return Attachment.new(value)
        else
          return nil
        end
    end

    def security_options_key
      [ "reply_enabled", "group_replies", "retention_period_type", "retention_period_value", "retention_period_unit",
       "encrypt_message", "double_encryption", "expiration_value", "expiration_unit", "security_code_length",
       "code_time_limit", "allowed_login_attempts", "allow_remember_me", "allow_sms", "allow_voice", "allow_email",
       "two_factor_required", "auto_extend_value", "auto_extend_unit", "allow_manual_delete",
       "allow_manual_close", "encrypt_attachments", "consent_group_id" ]
    end

  end
end