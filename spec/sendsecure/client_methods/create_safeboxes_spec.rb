require 'spec_helper'

describe SendSecure::ClientMethods::CreateSafeboxes do
  let(:client) { SendSecure::Client.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "submit_safebox" do
    let(:response_body) { { "guid" => "1c820789a50747df8746aa5d71922a3f",
                            "user_id" => 3,
                            "enterprise_id" => 1,
                            "subject" => nil,
                            "expiration" => "2016-12-06T05:38:09.951Z",
                            "notification_language" => "en",
                            "status"=>"in_progress",
                            "security_profile_name" => "email-only",
                            "security_code_length" => 4,
                            "allowed_login_attempts" => 3,
                            "allow_remember_me" => false,
                            "allow_sms" => false,
                            "allow_voice" => false,
                            "allow_email" => true,
                            "reply_enabled" => true,
                            "group_replies" => false,
                            "code_time_limit" => 5,
                            "encrypt_message" => false,
                            "two_factor_required" => true,
                            "auto_extend_value" => 3,
                            "auto_extend_unit" => "days",
                            "retention_period_type" => "discard_at_expiration",
                            "retention_period_value" => nil,
                            "retention_period_unit" => nil,
                            "delete_content_on" => nil,
                            "preview_url" => "http://sendsecure.lvh.me:3001/s/5b8e88acc9c44b229ba64256298f9388/preview?k=AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                            "encryption_key" => "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                            "created_at" => "2016-12-05T22:38:09.965Z",
                            "updated_at" => "2016-12-05T22:38:09.965Z",
                            "latest_activity" => "2016-12-05T22:38:10.068Z"
                          }
                        }

    it "initialize safebox when params are missing" do
      sb = SendSecure::SafeBox.new( { "user_email": "user@acme.com",
                                      "participants": [
                                        { "email": "recipient@test.xmedius.com",
                                          "guest_options": {
                                            "contact_methods": [
                                              { "destination_type": "cell_phone",
                                                "destination": "+15145550000" }
                                            ]
                                          }
                                        }
                                      ],
                                      "message": "lorem ipsum...",
                                      "notification_language": "en",
                                      "security_profile_id": 11 })

      expect_any_instance_of(SendSecure::Client).not_to receive(:enterprise_settings)
      expect_any_instance_of(SendSecure::Client).not_to receive(:upload_attachment)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:initialize_safebox).and_return(({ guid: "1c820789a50747df8746aa5d71922a3f", public_encryption_key: "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", upload_url: "upload_url"}).to_json)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:commit_safebox).and_return(response_body)
      client.submit_safebox(sb)
    end

    it "get default security profile when id missing" do
      sb = SendSecure::SafeBox.new( { "user_email": "user@acme.com",
                                      "participants": [
                                        { "email": "recipient@test.xmedius.com",
                                          "guest_options": {
                                            "contact_methods": [
                                              { "destination_type": "cell_phone",
                                                "destination": "+15145550000" }
                                            ]
                                          }
                                        }
                                      ],
                                      "message": "lorem ipsum...",
                                      "notification_language": "en" })

      enterprise_settings_response = {"created_at"=>"2016-03-15T19:58:11.588Z",
                                      "updated_at"=>"2016-09-28T18:32:16.643Z",
                                      "default_security_profile_id"=>10,
                                      "pdf_language"=>"fr",
                                      "use_pdfa_audit_records"=>false,
                                      "international_dialing_plan"=>"us",
                                      "extension_filter"=>{
                                        "mode"=>"forbid",
                                        "list"=>[]
                                      },
                                      "include_users_in_autocomplete"=>true,
                                      "include_favorites_in_autocomplete"=>true }

      expect_any_instance_of(SendSecure::JsonClient).not_to receive(:new_safebox)
      expect_any_instance_of(SendSecure::Client).to receive(:enterprise_settings).and_call_original
      expect_any_instance_of(SendSecure::Client).not_to receive(:upload_attachment)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:enterprise_setting).and_return(enterprise_settings_response)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:initialize_safebox).and_return(({ guid: "1c820789a50747df8746aa5d71922a3f", public_encryption_key: "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", upload_url: "upload_url"}).to_json)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:commit_safebox).and_return(response_body)
      client.submit_safebox(sb)
    end

    it "uploads documents" do
      sb = SendSecure::SafeBox.new( { "user_email": "user@acme.com",
                                      "participants": [
                                        { "email": "user@test.com",
                                          "guest_options": {
                                            "contact_methods": [
                                              { "destination_type": "cell_phone",
                                                "destination": "+15145550000" }
                                            ]
                                          }
                                        }
                                      ],
                                      "attachments": [
                                        { "file_path": Dir.pwd + "/spec/data/simple.pdf",
                                          "content_type": "application/pdf" }
                                      ],
                                      "notification_language": "fr",
                                      "security_profile_id": 11
                                    })

      expect_any_instance_of(SendSecure::JsonClient).not_to receive(:new_safebox)
      expect_any_instance_of(SendSecure::Client).not_to receive(:enterprise_settings)
      expect_any_instance_of(SendSecure::Client).to receive(:upload_attachment).and_call_original
      allow_any_instance_of(SendSecure::JsonClient).to receive(:upload_file).and_return({ "temporary_document"=>{"document_guid"=>"5d4d6a8158b04915a532622983eb4493"} })
      allow_any_instance_of(SendSecure::JsonClient).to receive(:initialize_safebox).and_return(({ guid: "1c820789a50747df8746aa5d71922a3f", public_encryption_key: "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", upload_url: "upload_url"}).to_json)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:commit_safebox).and_return(response_body)
      client.submit_safebox(sb)
    end

    it "return updated safebox" do
      sb = SendSecure::SafeBox.new( { "user_email": "user@acme.com",
                                      "participants": [
                                        { "email": "recipient@test.xmedius.com",
                                          "guest_options": {
                                            "contact_methods": [
                                              { "destination_type": "cell_phone",
                                                "destination": "+15145550000" }
                                            ]
                                          }
                                        }
                                      ],
                                      "message": "lorem ipsum...",
                                      "notification_language": "en",
                                      "security_profile_id": 11
                                    })
      allow_any_instance_of(SendSecure::JsonClient).to receive(:commit_safebox).and_return(response_body)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:initialize_safebox).and_return(({ guid: "1c820789a50747df8746aa5d71922a3f", public_encryption_key: "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", upload_url: "upload_url"}).to_json)
      result = client.submit_safebox(sb)
      expect(result.is_a?(SendSecure::SafeBox)).to eq(true)
      expect(result.security_options.is_a?(SendSecure::SecurityOptions)).to eq(true)
      expect(result.security_options.security_code_length).to eq(4)
      expect(result.guid).to eq("1c820789a50747df8746aa5d71922a3f")
      expect(result.preview_url).to eq("http://sendsecure.lvh.me:3001/s/5b8e88acc9c44b229ba64256298f9388/preview?k=AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz")
      expect(result.encryption_key).to eq("AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz")
    end

    it "raise error if recipients missing" do
      sb = SendSecure::SafeBox.new( { "user_email": "user@acme.com",
                                      "guid": "1c820789a50747df8746aa5d71922a3f",
                                      "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                                      "upload_url": "upload_url",
                                      "message": "lorem ipsum...",
                                      "notification_language": "en",
                                      "security_profile_id": 11
                                    })
      allow_any_instance_of(SendSecure::JsonClient).to receive(:initialize_safebox).and_return(({ guid: "1c820789a50747df8746aa5d71922a3f", public_encryption_key: "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", upload_url: "upload_url"}).to_json)
      expect{ client.submit_safebox(sb) }.to raise_error SendSecure::SendSecureException, "Recipient cannot be empty"
    end
  end

  context "upload_attachment" do

    it "uploads attachment and assign guid" do
      sb = SendSecure::SafeBox.new( { "user_email": "user@acme.com",
                                      "guid": "1c820789a50747df8746aa5d71922a3f",
                                      "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                                      "upload_url": "upload_url",
                                      "participants": [
                                        { "email": "user@test.com",
                                          "guest_options": {
                                            "contact_methods": [
                                              { "destination_type": "cell_phone",
                                              "destination": "+15145550000" }
                                            ]
                                          }
                                        }
                                      ],
                                      "notification_language": "fr",
                                      "security_profile_id": 11
                                    })

      attachment = SendSecure::Attachment.new({"file_path": Dir.pwd + "/spec/data/simple.pdf", "content_type": "application/pdf"})
      allow_any_instance_of(SendSecure::JsonClient).to receive(:upload_file).and_return({ "temporary_document"=>{"document_guid"=>"5d4d6a8158b04915a532622983eb4493"} })
      result = client.upload_attachment(sb, attachment)
      expect(result.is_a?(SendSecure::Attachment)).to eq(true)
      expect(result.guid).to eq("5d4d6a8158b04915a532622983eb4493")
    end
  end

end
