module SendSecure
  class DownloadActivityDocument < JSONable

    attr_reader   :id,
                  :downloaded_bytes,
                  :download_date

  end
end