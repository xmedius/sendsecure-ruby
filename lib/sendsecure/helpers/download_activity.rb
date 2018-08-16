module SendSecure
  class DownloadActivity < JSONable

    attr_reader   :guests, # List of DownloadActivityDetails
                  :owner   #see DownloadActivityDetail

    def guests
      @guests ||= []
    end

    def to_object(name, value)
      DownloadActivityDetail.new(value)
    end

  end
end