module SendSecure
  class ContactMethod < JSONable

    attr_accessor :destination_type, # ["home_phone", "cell_phone", "office_phone", "other_phone"]
                  :destination,
                  :_destroy

    attr_reader   :verified,
                  :created_at,
                  :updated_at,
                  :id

    def ignored_keys(params)
      keys = super(params) << "verified"
      keys << "id" if params[:is_creation]
      keys << "_destroy" unless params[:destroy_contacts]
      keys
    end

  end
end
