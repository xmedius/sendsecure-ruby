module SendSecure
  class GuestOptions < JSONable

    attr_reader   :bounced_email,
                  :failed_login_attempts,
                  :verified,
                  :created_at,
                  :updated_at

    attr_accessor :company_name,
                  :locked,
                  :contact_methods # List of ContactMethods

    def contact_methods
      @contact_methods ||= []
    end

    def hashable_keys(params)
      keys = ["company_name", "contact_methods"]
      keys << "locked" unless params[:is_creation]
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

  end
end
