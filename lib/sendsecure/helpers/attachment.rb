module SendSecure


    class Attachment < JSONable
      attr_accessor :guid
      attr_reader   :filename, :content_type, :file, :file_path

      # def initialize(file_path, content_type)
      #   @file_path = file_path
      #   @content_type = content_type
      # end

      # def initialize(file, filename, content_type)
      #   @file = file
      #   @filename = filename
      #   @content_type = content_type
      # end

    end


end
