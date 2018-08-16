module SendSecure
  class Message < JSONable

    attr_reader   :id,
                  :note,
                  :note_size,
                  :read,
                  :author_id,
                  :author_type,
                  :created_at,
                  :documents # List of MessageDocuments

    def documents
      @documents ||= []
    end

    def to_object(name, value)
      name == :documents ? MessageDocument.new(value) : nil
    end

  end
end