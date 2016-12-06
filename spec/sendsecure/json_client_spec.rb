require 'spec_helper'

describe SendSecure::JsonClient do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new("USER|489b3b1f-b411-428e-be5b-2abbace87689", "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "get_user_token" do

    it "return token on success" do
      response = Faraday::Response.new()
      response.finish({status: 200, response_headers:{}, body: ({ result: true, token: "USER|489b3b1f-b411-428e-be5b-2abbace87689" }).to_json })
      allow(Faraday).to receive(:post).and_return(response)
      expect(SendSecure::JsonClient.get_user_token("acme", "username", "password", "device_id", "device_name")).to eq("USER|489b3b1f-b411-428e-be5b-2abbace87689")
    end

    it "raise exception on failure" do
      response = Faraday::Response.new()
      response.finish({status: 401, response_headers:{}, body: ({result:false, message:"invalid credentials", code:102}).to_json })
      allow(Faraday).to receive(:post).and_return(response)
      expect { SendSecure::JsonClient.get_user_token("acme", "invalid_username", "password", "device_id", "device_name") }.to raise_error SendSecure::SendSecureException, "invalid credentials"
    end
  end

  context "new_safebox" do

    it "return new safebox on success" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/safeboxes/new?user_email=user@acme.com&locale=en") { |env| [ 200, {}, ({ guid: "guid", public_encryption_key: "key", upload_url: "url"}).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      safebox = client.new_safebox("user@acme.com")
      expect(safebox.has_key?("guid")).to be true
      expect(safebox.has_key?("public_encryption_key")).to be true
      expect(safebox.has_key?("upload_url")).to be true
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/safeboxes/new?user_email=invalid_user@acme.com&locale=en") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.new_safebox("invalid_user@acme.com") }.to raise_error SendSecure::SendSecureException, "Access denied"
    end
  end

  context "commit_safebox" do
    let(:safebox_json) { {safebox: { "guid": "1c820789a50747df8746aa5d71922a3f", "recipients": [ {"email": "recipient@test.xmedius.com",
                                  "contact_methods": [{"destination_type": "cell_phone","destination": "+15145550000"}]}],
                                  "message": "lorem ipsum...", "security_profile_id": 10, "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                                  "notification_language": "en" }} }

    it "return safebox info on success" do
      response_body = {"guid"=>"1c820789a50747df8746aa5d71922a3f", "user_id"=>3, "enterprise_id"=>1, "subject"=>nil, "expiration"=>"2016-12-06T05:38:09.951Z", "notification_language"=>"en",
                        "status"=>"in_progress", "security_profile_name"=>"email-only", "force_expiry_date"=>nil, "security_code_length"=>4, "allowed_login_attempts"=>3, "allow_remember_me"=>false,
                        "allow_sms"=>false, "allow_voice"=>false, "allow_email"=>true, "reply_enabled"=>true, "group_replies"=>false, "code_time_limit"=>5, "encrypt_message"=>false,
                        "two_factor_required"=>true, "auto_extend_value"=>3, "auto_extend_unit"=>"days", "retention_period_type"=>"discard_at_expiration", "retention_period_value"=>nil,
                        "retention_period_unit"=>nil, "delete_content_on"=>nil, "preview_url"=>"http://sendsecure.lvh.me:3001/s/5b8e88acc9c44b229ba64256298f9388/preview?k=AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                        "encryption_key"=>"AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", "created_at"=>"2016-12-05T22:38:09.965Z", "updated_at"=>"2016-12-05T22:38:09.965Z", "latest_activity"=>"2016-12-05T22:38:10.068Z"}
      sendsecure_connection do |stubs|
        stubs.post("/api/v2/safeboxes", safebox_json) { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.commit_safebox(safebox_json)
      expect(result.has_key?("guid")).to be true
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.post("/api/v2/safeboxes", safebox_json) { |env| [ 400, {}, {"error"=>"Some entered values are incorrect.", "attributes"=>{"language"=>["cannot be blank"]}} ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.commit_safebox(safebox_json) }.to raise_error SendSecure::SendSecureException, "Some entered values are incorrect. {\"language\"=>[\"cannot be blank\"]}"
    end
  end

  context "upload_file" do
    let(:client) { SendSecure::JsonClient.new("USER|489b3b1f-b411-428e-be5b-2abbace87689", "acme") }

    it "return document guid on success" do
      stubs = Faraday.new do |builder|
        builder.request :multipart
        builder.response :json, content_type: /\bjson$/

        builder.adapter :test do |stubs|
          stubs.post("http://upload_url") { |env| [ 200, {}, {"temporary_document"=>{"document_guid"=>"5d4d6a8158b04915a532622983eb4493"}} ]}
        end
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:fileserver_connection).and_return(stubs)
      response = client.upload_file("http://upload_url", Dir.pwd + "/spec/data/simple.pdf", "application/pdf")
      expect(response["temporary_document"]["document_guid"]).to eq("5d4d6a8158b04915a532622983eb4493")
    end
  end


  context "security_profiles" do

    it "return security_profiles on success" do
      response_body = {"security_profiles"=>[
        {"id"=>5, "name"=>"reply", "description"=>"no email", "created_at"=>"2016-04-19T16:26:18.277Z", "updated_at"=>"2016-09-07T19:33:51.192Z", "allowed_login_attempts"=>{"value"=>3, "modifiable"=>false}, "allow_remember_me"=>{"value"=>false, "modifiable"=>false}, "allow_sms"=>{"value"=>true, "modifiable"=>false}, "allow_voice"=>{"value"=>true, "modifiable"=>false}, "allow_email"=>{"value"=>false, "modifiable"=>false}, "code_time_limit"=>{"value"=>5, "modifiable"=>false}, "code_length"=>{"value"=>4, "modifiable"=>false}, "auto_extend_value"=>{"value"=>1, "modifiable"=>false}, "auto_extend_unit"=>{"value"=>"days", "modifiable"=>false}, "two_factor_required"=>{"value"=>true, "modifiable"=>false}, "encrypt_attachments"=>{"value"=>true, "modifiable"=>false}, "encrypt_message"=>{"value"=>false, "modifiable"=>false}, "expiration_value"=>{"value"=>3, "modifiable"=>true}, "expiration_unit"=>{"value"=>"hours", "modifiable"=>true}, "reply_enabled"=>{"value"=>true, "modifiable"=>false}, "group_replies"=>{"value"=>false, "modifiable"=>false}, "double_encryption"=>{"value"=>false, "modifiable"=>false}, "retention_period_type"=>{"value"=>"do_not_discard", "modifiable"=>false}, "retention_period_value"=>{"value"=>nil, "modifiable"=>false}, "retention_period_unit"=>{"value"=>"hours", "modifiable"=>false}},
        {"id"=>10, "name"=>"email-only", "description"=>"", "created_at"=>"2016-04-27T21:08:29.457Z", "updated_at"=>"2016-07-27T19:03:05.883Z", "allowed_login_attempts"=>{"value"=>3, "modifiable"=>false}, "allow_remember_me"=>{"value"=>false, "modifiable"=>false}, "allow_sms"=>{"value"=>false, "modifiable"=>false}, "allow_voice"=>{"value"=>false, "modifiable"=>false}, "allow_email"=>{"value"=>true, "modifiable"=>false}, "code_time_limit"=>{"value"=>5, "modifiable"=>false}, "code_length"=>{"value"=>4, "modifiable"=>false}, "auto_extend_value"=>{"value"=>3, "modifiable"=>false}, "auto_extend_unit"=>{"value"=>"days", "modifiable"=>false}, "two_factor_required"=>{"value"=>true, "modifiable"=>false}, "encrypt_attachments"=>{"value"=>true, "modifiable"=>false}, "encrypt_message"=>{"value"=>false, "modifiable"=>false}, "expiration_value"=>{"value"=>7, "modifiable"=>false}, "expiration_unit"=>{"value"=>"hours", "modifiable"=>false}, "reply_enabled"=>{"value"=>true, "modifiable"=>false}, "group_replies"=>{"value"=>false, "modifiable"=>false}, "double_encryption"=>{"value"=>true, "modifiable"=>false}, "retention_period_type"=>{"value"=>"discard_at_expiration", "modifiable"=>false}, "retention_period_value"=>{"value"=>nil, "modifiable"=>false}, "retention_period_unit"=>{"value"=>nil, "modifiable"=>false}}
        ]}
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/security_profiles?user_email=user@acme.com&locale=en") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.security_profiles("user@acme.com")
      expect(result["security_profiles"].size).to eq(2)
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/security_profiles?user_email=invalid_user@acme.com&locale=en") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.security_profiles("invalid_user@acme.com") }.to raise_error SendSecure::SendSecureException, "Access denied"
    end
  end

  context "enterprise_setting" do

    it "return enterprise_setting on success" do
      response_body = {"created_at"=>"2016-03-15T19:58:11.588Z", "updated_at"=>"2016-09-28T18:32:16.643Z", "default_security_profile_id"=>10, "pdf_language"=>"fr", "use_pdfa_audit_records"=>false,
        "international_dialing_plan"=>"us", "extension_filter"=>{"mode"=>"forbid", "list"=>[]}, "include_users_in_autocomplete"=>true, "include_favorites_in_autocomplete"=>true}
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/settings?locale=en") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.enterprise_setting
      expect(result["default_security_profile_id"]).to eq(10)
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/settings?locale=en") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.enterprise_setting }.to raise_error SendSecure::SendSecureException, "Access denied"
    end
  end

end
