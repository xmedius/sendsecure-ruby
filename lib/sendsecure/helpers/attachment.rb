module SendSecure
  class Attachment < JSONable

    attr_accessor :guid
    attr_reader   :filename, :content_type, :file, :file_path

  end
end
