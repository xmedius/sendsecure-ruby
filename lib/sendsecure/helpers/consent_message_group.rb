module SendSecure
  class ConsentMessageGroup < JSONable

    attr_reader   :id,
                  :name,
                  :created_at,
                  :updated_at,
                  :consent_messages # List of ConsentMessage

    def consent_messages
    	@consent_messages ||= []
    end

    def to_object(name, value)
      name == :consent_messages ? ConsentMessage.new(value) : nil
    end

  end
end
