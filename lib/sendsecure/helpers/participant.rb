module SendSecure
  class Participant < JSONable

    attr_reader   :id,
                  :type,
                  :role,
                  :message_read_count,
                  :message_total_count

    attr_accessor :first_name,
                  :last_name,
                  :email,
                  :guest_options #see GuestOption

    def to_hash(params = {})
      hash = super(params)
      self.guest_options.nil? ? hash : hash.merge(self.guest_options.to_hash(params))
    end

    def hashable_keys(params)
      ["first_name", "last_name", "email"]
    end

    def to_object(name, value)
      name == :guest_options ? GuestOptions.new(value) : nil
    end

    def prepare_to_destroy_contact(contact_method_ids)
      self.guest_options.contact_methods.map! do |c|
        c._destroy = true if contact_method_ids.include?(c.id)
        c
      end
    end

  end
end
