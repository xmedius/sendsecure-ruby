require 'spec_helper'

describe SendSecure::UserSetting do
  let(:settings) { SendSecure::UserSetting.new( { "created_at": "2016-08-15T21:56:45.798Z",
                                                  "updated_at": "2017-04-10T18:58:59.356Z",
                                                  "mask_note": false,
                                                  "open_first_transaction": false,
                                                  "mark_as_read": true,
                                                  "mark_as_read_delay": 5,
                                                  "remember_key": true,
                                                  "default_filter": "everything",
                                                  "recipient_language": nil,
                                                  "secure_link": {
                                                    "enabled": true,
                                                    "url": "https://sendsecure.integration.xmedius.com/r/612328d944b842c68418375ffdc87b3f",
                                                    "security_profile_id": 1 }
                                                }) }

  context "create user setting with" do

    it "all the basic attributes" do
      expect(settings.created_at).to eq("2016-08-15T21:56:45.798Z")
      expect(settings.updated_at).to eq("2017-04-10T18:58:59.356Z")
      expect(settings.mask_note).to eq(false)
      expect(settings.open_first_transaction).to eq(false)
      expect(settings.mark_as_read).to eq(true)
      expect(settings.mark_as_read_delay).to eq(5)
      expect(settings.remember_key).to eq(true)
      expect(settings.default_filter).to eq("everything")
      expect(settings.recipient_language).to be_nil
    end

    it "persnnal secure link attributes" do
      secure_link = settings.secure_link
      expect(secure_link.is_a?(SendSecure::PersonnalSecureLink)).to eq(true)
      expect(secure_link.enabled).to eq(true)
      expect(secure_link.url).to eq("https://sendsecure.integration.xmedius.com/r/612328d944b842c68418375ffdc87b3f")
      expect(secure_link.security_profile_id).to eq(1)
    end

  end

end