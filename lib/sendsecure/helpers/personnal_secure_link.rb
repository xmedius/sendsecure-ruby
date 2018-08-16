module SendSecure
  class PersonnalSecureLink < JSONable

    attr_reader   :enabled,
                  :url,
                  :security_profile_id

  end
end