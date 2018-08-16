module SendSecure
  class EventHistory < JSONable

    attr_reader   :type,
                  :date,
                  :metadata, # { emails: <List of strings>, attachment_count: <attachment_count> }
                  :message

  end
end
