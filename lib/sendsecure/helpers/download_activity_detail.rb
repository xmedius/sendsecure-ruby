module SendSecure
  class DownloadActivityDetail < JSONable

    attr_reader   :id,
                  :documents # List of DownloadActivityDocuments

    def documents
      @documents ||= []
    end

    def to_object(name, value)
      name == :documents ? DownloadActivityDocument.new(value) : nil
    end

  end
end