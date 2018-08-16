module SendSecure
  class UserSetting < JSONable

    attr_reader   :created_at,
                  :updated_at,
                  :mask_note,
                  :open_first_transaction,
                  :mark_as_read,
                  :mark_as_read_delay,
                  :remember_key,
                  :default_filter,      #[:everything, :in_progress, :closed, :content_deleted, :unread]
                  :recipient_language,
                  :secure_link          # see PersonnalSecureLink

    def to_object(name, value)
      name == :secure_link ? PersonnalSecureLink.new(value) : nil
    end

  end
end