module SendSecure
  class ConsentMessage < JSONable

    attr_reader   :locale,
                  :value,
                  :created_at,
                  :updated_at

  end
end