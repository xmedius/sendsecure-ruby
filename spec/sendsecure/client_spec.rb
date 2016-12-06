require 'spec_helper'

describe SendSecure::Client do
  let(:client) { SendSecure::Client.new("USER|489b3b1f-b411-428e-be5b-2abbace87689", "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "commit_safebox" do
    let(:response_body) { {"guid"=>"1c820789a50747df8746aa5d71922a3f", "user_id"=>3, "enterprise_id"=>1, "subject"=>nil, "expiration"=>"2016-12-06T05:38:09.951Z", "notification_language"=>"en",
                        "status"=>"in_progress", "security_profile_name"=>"email-only", "force_expiry_date"=>nil, "security_code_length"=>4, "allowed_login_attempts"=>3, "allow_remember_me"=>false,
                        "allow_sms"=>false, "allow_voice"=>false, "allow_email"=>true, "reply_enabled"=>true, "group_replies"=>false, "code_time_limit"=>5, "encrypt_message"=>false,
                        "two_factor_required"=>true, "auto_extend_value"=>3, "auto_extend_unit"=>"days", "retention_period_type"=>"discard_at_expiration", "retention_period_value"=>nil,
                        "retention_period_unit"=>nil, "delete_content_on"=>nil, "preview_url"=>"http://sendsecure.lvh.me:3001/s/5b8e88acc9c44b229ba64256298f9388/preview?k=AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                        "encryption_key"=>"AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", "created_at"=>"2016-12-05T22:38:09.965Z", "updated_at"=>"2016-12-05T22:38:09.965Z", "latest_activity"=>"2016-12-05T22:38:10.068Z"}
                      }

    it "initialize safebox when params are missing" do
      sb = SendSecure::SafeBox.new({ "user_email": "user@acme.com", "recipients": [ {"email": "recipient@test.xmedius.com",
                                  "contact_methods": [{"destination_type": "cell_phone","destination": "+15145550000"}]}],
                                  "message": "lorem ipsum...", "notification_language": "en", "security_profile_id": 11 })
      expect_any_instance_of(SendSecure::Client).to receive(:finalize_safebox).and_call_original
      expect_any_instance_of(SendSecure::Client).not_to receive(:enterprise_settings)
      expect_any_instance_of(SendSecure::Client).not_to receive(:upload_attachment)

      allow_any_instance_of(SendSecure::JsonClient).to receive(:new_safebox).and_return(({ guid: "1c820789a50747df8746aa5d71922a3f", public_encryption_key: "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", upload_url: "upload_url"}).to_json)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:commit_safebox).and_return(response_body)
      expect(client.commit_safebox(sb)).to eq(response_body)
    end

    it "get default security profile when id missing" do
      sb = SendSecure::SafeBox.new({ "user_email": "user@acme.com", "guid": "1c820789a50747df8746aa5d71922a3f", "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", "upload_url": "upload_url",
                                    "recipients": [ {"email": "recipient@test.xmedius.com", "contact_methods": [{"destination_type": "cell_phone","destination": "+15145550000"}]}],
                                    "message": "lorem ipsum...", "notification_language": "en" })
      expect_any_instance_of(SendSecure::Client).to receive(:finalize_safebox).and_call_original
      expect_any_instance_of(SendSecure::JsonClient).not_to receive(:new_safebox)
      expect_any_instance_of(SendSecure::Client).to receive(:enterprise_settings).and_call_original
      expect_any_instance_of(SendSecure::Client).not_to receive(:upload_attachment)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:enterprise_setting).and_return({"created_at"=>"2016-03-15T19:58:11.588Z", "updated_at"=>"2016-09-28T18:32:16.643Z", "default_security_profile_id"=>10,
        "pdf_language"=>"fr", "use_pdfa_audit_records"=>false, "international_dialing_plan"=>"us", "extension_filter"=>{"mode"=>"forbid", "list"=>[]}, "include_users_in_autocomplete"=>true, "include_favorites_in_autocomplete"=>true})
      allow_any_instance_of(SendSecure::JsonClient).to receive(:commit_safebox).and_return(response_body)
      expect(client.commit_safebox(sb)).to eq(response_body)
    end

    it "uploads documents" do
      sb = SendSecure::SafeBox.new( { "user_email": "user@acme.com", "guid": "1c820789a50747df8746aa5d71922a3f", "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", "upload_url": "upload_url",
        "recipients": [ {"email": "user@test.com", "contact_methods": [{"destination_type": "cell_phone","destination": "+15145550000"}]}],
        "attachments": [ {"file_path": Dir.pwd + "/spec/data/simple.pdf", "content_type": "application/pdf"}],
        "notification_language": "fr", "security_profile_id": 11 })
      expect_any_instance_of(SendSecure::Client).to receive(:finalize_safebox).and_call_original
      expect_any_instance_of(SendSecure::JsonClient).not_to receive(:new_safebox)
      expect_any_instance_of(SendSecure::Client).not_to receive(:enterprise_settings)
      expect_any_instance_of(SendSecure::Client).to receive(:upload_attachment).and_call_original
      allow_any_instance_of(SendSecure::JsonClient).to receive(:upload_file).and_return({"temporary_document"=>{"document_guid"=>"5d4d6a8158b04915a532622983eb4493"}})
      allow_any_instance_of(SendSecure::JsonClient).to receive(:commit_safebox).and_return(response_body)
      expect(client.commit_safebox(sb)).to eq(response_body)
    end
  end

  context "security_profiles" do

    it "return list of security profiles" do
      response_body = {"security_profiles"=>[
        {"id"=>5, "name"=>"reply", "description"=>"no email", "created_at"=>"2016-04-19T16:26:18.277Z", "updated_at"=>"2016-09-07T19:33:51.192Z", "allowed_login_attempts"=>{"value"=>3, "modifiable"=>false}, "allow_remember_me"=>{"value"=>false, "modifiable"=>false}, "allow_sms"=>{"value"=>true, "modifiable"=>false}, "allow_voice"=>{"value"=>true, "modifiable"=>false}, "allow_email"=>{"value"=>false, "modifiable"=>false}, "code_time_limit"=>{"value"=>5, "modifiable"=>false}, "code_length"=>{"value"=>4, "modifiable"=>false}, "auto_extend_value"=>{"value"=>1, "modifiable"=>false}, "auto_extend_unit"=>{"value"=>"days", "modifiable"=>false}, "two_factor_required"=>{"value"=>true, "modifiable"=>false}, "encrypt_attachments"=>{"value"=>true, "modifiable"=>false}, "encrypt_message"=>{"value"=>false, "modifiable"=>false}, "expiration_value"=>{"value"=>3, "modifiable"=>true}, "expiration_unit"=>{"value"=>"hours", "modifiable"=>true}, "reply_enabled"=>{"value"=>true, "modifiable"=>false}, "group_replies"=>{"value"=>false, "modifiable"=>false}, "double_encryption"=>{"value"=>false, "modifiable"=>false}, "retention_period_type"=>{"value"=>"do_not_discard", "modifiable"=>false}, "retention_period_value"=>{"value"=>nil, "modifiable"=>false}, "retention_period_unit"=>{"value"=>"hours", "modifiable"=>false}},
        {"id"=>10, "name"=>"email-only", "description"=>"", "created_at"=>"2016-04-27T21:08:29.457Z", "updated_at"=>"2016-07-27T19:03:05.883Z", "allowed_login_attempts"=>{"value"=>3, "modifiable"=>false}, "allow_remember_me"=>{"value"=>false, "modifiable"=>false}, "allow_sms"=>{"value"=>false, "modifiable"=>false}, "allow_voice"=>{"value"=>false, "modifiable"=>false}, "allow_email"=>{"value"=>true, "modifiable"=>false}, "code_time_limit"=>{"value"=>5, "modifiable"=>false}, "code_length"=>{"value"=>4, "modifiable"=>false}, "auto_extend_value"=>{"value"=>3, "modifiable"=>false}, "auto_extend_unit"=>{"value"=>"days", "modifiable"=>false}, "two_factor_required"=>{"value"=>true, "modifiable"=>false}, "encrypt_attachments"=>{"value"=>true, "modifiable"=>false}, "encrypt_message"=>{"value"=>false, "modifiable"=>false}, "expiration_value"=>{"value"=>7, "modifiable"=>false}, "expiration_unit"=>{"value"=>"hours", "modifiable"=>false}, "reply_enabled"=>{"value"=>true, "modifiable"=>false}, "group_replies"=>{"value"=>false, "modifiable"=>false}, "double_encryption"=>{"value"=>true, "modifiable"=>false}, "retention_period_type"=>{"value"=>"discard_at_expiration", "modifiable"=>false}, "retention_period_value"=>{"value"=>nil, "modifiable"=>false}, "retention_period_unit"=>{"value"=>nil, "modifiable"=>false}}
        ]}
      allow_any_instance_of(SendSecure::JsonClient).to receive(:security_profiles).and_return(response_body)
      result = client.security_profiles("user@acme.com")
      expect(result.size).to eq(2)
      expect(result[0].is_a?(SendSecure::SecurityProfile)).to eq(true)
    end
  end

  context "enterprise_settings" do

    it "return enterprise_setting" do
      response_body = {"created_at"=>"2016-03-15T19:58:11.588Z", "updated_at"=>"2016-09-28T18:32:16.643Z", "default_security_profile_id"=>10, "pdf_language"=>"fr", "use_pdfa_audit_records"=>false,
        "international_dialing_plan"=>"us", "extension_filter"=>{"mode"=>"forbid", "list"=>[]}, "include_users_in_autocomplete"=>true, "include_favorites_in_autocomplete"=>true}
      allow_any_instance_of(SendSecure::JsonClient).to receive(:enterprise_setting).and_return(response_body)
      result = client.enterprise_settings
      expect(result.is_a?(SendSecure::EnterpriseSetting)).to eq(true)
      expect(result.default_security_profile_id).to eq(10)
    end
  end

  context "default_security_profile" do

    it "return default_security_profile" do
      enterprise_setting_response = {"created_at"=>"2016-03-15T19:58:11.588Z", "updated_at"=>"2016-09-28T18:32:16.643Z", "default_security_profile_id"=>10, "pdf_language"=>"fr", "use_pdfa_audit_records"=>false,
        "international_dialing_plan"=>"us", "extension_filter"=>{"mode"=>"forbid", "list"=>[]}, "include_users_in_autocomplete"=>true, "include_favorites_in_autocomplete"=>true}
      security_profiles_response = {"security_profiles"=>[
        {"id"=>5, "name"=>"reply", "description"=>"no email", "created_at"=>"2016-04-19T16:26:18.277Z", "updated_at"=>"2016-09-07T19:33:51.192Z", "allowed_login_attempts"=>{"value"=>3, "modifiable"=>false}, "allow_remember_me"=>{"value"=>false, "modifiable"=>false}, "allow_sms"=>{"value"=>true, "modifiable"=>false}, "allow_voice"=>{"value"=>true, "modifiable"=>false}, "allow_email"=>{"value"=>false, "modifiable"=>false}, "code_time_limit"=>{"value"=>5, "modifiable"=>false}, "code_length"=>{"value"=>4, "modifiable"=>false}, "auto_extend_value"=>{"value"=>1, "modifiable"=>false}, "auto_extend_unit"=>{"value"=>"days", "modifiable"=>false}, "two_factor_required"=>{"value"=>true, "modifiable"=>false}, "encrypt_attachments"=>{"value"=>true, "modifiable"=>false}, "encrypt_message"=>{"value"=>false, "modifiable"=>false}, "expiration_value"=>{"value"=>3, "modifiable"=>true}, "expiration_unit"=>{"value"=>"hours", "modifiable"=>true}, "reply_enabled"=>{"value"=>true, "modifiable"=>false}, "group_replies"=>{"value"=>false, "modifiable"=>false}, "double_encryption"=>{"value"=>false, "modifiable"=>false}, "retention_period_type"=>{"value"=>"do_not_discard", "modifiable"=>false}, "retention_period_value"=>{"value"=>nil, "modifiable"=>false}, "retention_period_unit"=>{"value"=>"hours", "modifiable"=>false}},
        {"id"=>10, "name"=>"email-only", "description"=>"", "created_at"=>"2016-04-27T21:08:29.457Z", "updated_at"=>"2016-07-27T19:03:05.883Z", "allowed_login_attempts"=>{"value"=>3, "modifiable"=>false}, "allow_remember_me"=>{"value"=>false, "modifiable"=>false}, "allow_sms"=>{"value"=>false, "modifiable"=>false}, "allow_voice"=>{"value"=>false, "modifiable"=>false}, "allow_email"=>{"value"=>true, "modifiable"=>false}, "code_time_limit"=>{"value"=>5, "modifiable"=>false}, "code_length"=>{"value"=>4, "modifiable"=>false}, "auto_extend_value"=>{"value"=>3, "modifiable"=>false}, "auto_extend_unit"=>{"value"=>"days", "modifiable"=>false}, "two_factor_required"=>{"value"=>true, "modifiable"=>false}, "encrypt_attachments"=>{"value"=>true, "modifiable"=>false}, "encrypt_message"=>{"value"=>false, "modifiable"=>false}, "expiration_value"=>{"value"=>7, "modifiable"=>false}, "expiration_unit"=>{"value"=>"hours", "modifiable"=>false}, "reply_enabled"=>{"value"=>true, "modifiable"=>false}, "group_replies"=>{"value"=>false, "modifiable"=>false}, "double_encryption"=>{"value"=>true, "modifiable"=>false}, "retention_period_type"=>{"value"=>"discard_at_expiration", "modifiable"=>false}, "retention_period_value"=>{"value"=>nil, "modifiable"=>false}, "retention_period_unit"=>{"value"=>nil, "modifiable"=>false}}
        ]}
      allow_any_instance_of(SendSecure::JsonClient).to receive(:security_profiles).and_return(security_profiles_response)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:enterprise_setting).and_return(enterprise_setting_response)
      result = client.default_security_profile("user@acme.com")
      expect(result.is_a?(SendSecure::SecurityProfile)).to eq(true)
      expect(result.id).to eq(10)
    end
  end

  context "upload_attachment" do

    it "uploads attachment and assign guid" do
      sb = SendSecure::SafeBox.new( { "user_email": "user@acme.com", "guid": "1c820789a50747df8746aa5d71922a3f", "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", "upload_url": "upload_url",
        "recipients": [ {"email": "user@test.com", "contact_methods": [{"destination_type": "cell_phone","destination": "+15145550000"}]}],
        "notification_language": "fr", "security_profile_id": 11 })
      attachment = SendSecure::Attachment.new({"file_path": Dir.pwd + "/spec/data/simple.pdf", "content_type": "application/pdf"})
      allow_any_instance_of(SendSecure::JsonClient).to receive(:upload_file).and_return({"temporary_document"=>{"document_guid"=>"5d4d6a8158b04915a532622983eb4493"}})
      result = client.upload_attachment(sb, attachment)
      expect(result.is_a?(SendSecure::Attachment)).to eq(true)
      expect(result.guid).to eq("5d4d6a8158b04915a532622983eb4493")
    end
  end

end
