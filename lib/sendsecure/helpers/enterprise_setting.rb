module SendSecure
  class EnterpriseSetting < JSONable

    attr_reader   :created_at,
                  :updated_at,
                  :default_security_profile_id,
                  :pdf_language,
                  :use_pdfa_audit_records,
                  :international_dialing_plan,
                  :extension_filter, # see ExtensionFilter
                  :virus_scan_enabled,
                  :max_file_size_value,
                  :max_file_size_unit,
                  :include_users_in_autocomplete,
                  :include_favorites_in_autocomplete,
                  :users_public_url

    def to_object(name, value)
      name == :extension_filter ? ExtensionFilter.new(value) : nil
    end

  end
end