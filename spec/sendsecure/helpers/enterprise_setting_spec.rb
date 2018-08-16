require 'spec_helper'

describe SendSecure::EnterpriseSetting do
  let(:settings) { SendSecure::EnterpriseSetting.new( { "created_at": "2016-04-27T21:08:29.457Z",
                                                        "updated_at": "2016-07-27T19:03:05.883Z",
                                                        "default_security_profile_id": 1,
                                                        "pdf_language": "en",
                                                        "use_pdfa_audit_records": false,
                                                        "international_dialing_plan": "ca",
                                                        "extension_filter": { "mode": "forbid",
                                                                              "list": ["bin", "bat"] },
                                                        "virus_scan_enabled": false,
                                                        "max_file_size_value": nil,
                                                        "max_file_size_unit": nil,
                                                        "include_users_in_autocomplete": true,
                                                        "include_favorites_in_autocomplete": true,
                                                        "users_public_url": true
                                                      }) }

  context "create enterprise setting with" do

    it "all the basic attributes" do
      expect(settings.created_at).to eq("2016-04-27T21:08:29.457Z")
      expect(settings.updated_at).to eq("2016-07-27T19:03:05.883Z")
      expect(settings.default_security_profile_id).to eq(1)
      expect(settings.pdf_language).to eq("en")
      expect(settings.use_pdfa_audit_records).to eq(false)
      expect(settings.international_dialing_plan).to eq("ca")
      expect(settings.virus_scan_enabled).to eq(false)
      expect(settings.max_file_size_value).to be_nil
      expect(settings.max_file_size_unit).to be_nil
      expect(settings.include_users_in_autocomplete).to eq(true)
      expect(settings.include_favorites_in_autocomplete).to eq(true)
      expect(settings.users_public_url).to eq(true)
    end

    it "extension filter attributes" do
      extension_filter = settings.extension_filter
      expect(extension_filter.is_a?(SendSecure::ExtensionFilter)).to eq(true)
      expect(extension_filter.mode).to eq("forbid")
      expect(extension_filter.list).to eq(["bin", "bat"])
    end

  end

end