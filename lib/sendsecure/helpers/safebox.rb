module SendSecure


    class SafeBox < JSONable
      attr_accessor :guid,
                    :public_encryption_key,
                    :upload_url,
                    :user_email,
                    :recipients, # List of Recipients
                    :subject,
                    :message,
                    :attachments, # List of Attachments -> document_ids
                    :notification_language,
                    :security_profile_id,
                    # Customized security options:
                    :reply_enabled,
                    :group_replies,
                    :expiration_value,
                    :expiration_unit,
                    :retention_period_type,
                    :encrypt_message,
                    :double_encryption

      # TimeUnit ["hours", "days", "weeks", "months"]
      # LongTimeUnit ["hours", "days", "weeks", "months", "years"]
      # RetentionPeriodType ["discard_at_expiration", "retain_at_expiration", "do_not_discard"]


      def initialize(params)
        params.each do |key, value|
          if key == :recipients
            instance_variable_set("@#{key}", value.map { |r| Recipient.new(r) })
          elsif key == :attachments
            instance_variable_set("@#{key}", value.map { |a| Attachment.new(a) })
          else
            instance_variable_set("@#{key}", value)
          end
        end
      end

      def attachments
        @attachments || []
      end

      def recipients
        @recipients || []
      end

      def to_hash
        hash = {}
        self.instance_variables.each do |var|
          key = var.to_s.delete "@"
          if key == "attachments"
            hash["document_ids"] = self.attachments.map { |a| a.guid }
          elsif key == "recipients"
            hash[key] = self.recipients.map { |r| r.to_hash }
          else
            hash[key] = self.instance_variable_get var
          end
        end
        hash
      end

    end


end
