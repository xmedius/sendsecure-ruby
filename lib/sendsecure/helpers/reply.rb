module SendSecure
  class Reply < JSONable

    attr_accessor :message,
                  :consent, #Optional
                  :attachments,
                  :document_ids

    def attachments
      @attachments ||= []
    end

    def document_ids
      @document_ids ||= []
    end

    def hashable_keys(params)
      [ "message", "consent", "document_ids" ]
    end

    def to_json(params = {})
      { "safebox" => self.to_hash(params) }
    end

  end
end