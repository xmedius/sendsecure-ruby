module SendSecure
  class Favorite < JSONable

    attr_reader   :id,
                  :created_at,
                  :updated_at

    attr_accessor :first_name,
                  :last_name,
                  :email,
                  :order_number,
                  :company_name,
                  :contact_methods # List of ContactMethods

    def contact_methods
      @contact_methods ||= []
    end

    def ignored_keys(params)
      keys = super(params) << "id"
      keys << "order_number" if params[:is_creation]
      keys
    end

    def to_object(name, value)
      name == :contact_methods ? ContactMethod.new(value) : nil
    end

    def update_attributes(params)
      new_params = {}
      params.each{ |key, value| new_params[key.to_sym] = value }
      unless new_params[:contact_methods].nil?
        contacts_id = new_params[:contact_methods].map { |c| c[:id] }
        @contact_methods = @contact_methods.delete_if { |c| !c.id.nil? && !contacts_id.include?(c.id) }
      end
      super(new_params)
    end

    def prepare_to_destroy_contact(contact_method_ids)
      self.contact_methods.map! do |c|
        c._destroy = true if contact_method_ids.include?(c.id)
        c
      end
    end

  end
end
