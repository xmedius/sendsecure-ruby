module SendSecure
  class MessageDocument < JSONable

    attr_reader   :id,
                  :name,
                  :sha,
                  :size,
                  :url

  end
end