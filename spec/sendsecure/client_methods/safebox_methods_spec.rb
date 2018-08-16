require 'spec_helper'

describe SendSecure::ClientMethods::SafeboxMethods do
  let(:client) { SendSecure::Client.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }
  let(:safebox) { SendSecure::SafeBox.new({ "guid": "1c820789a50747df8746aa5d71922a3f",
                                            "user_email": "user@acme.com",
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
                                            "user_id": 3,
                                            "enterprise_id": 1,
                                            "subject": nil,
                                            "expiration": "2016-12-06T05:38:09.951Z",
                                            "notification_language": "en",
                                            "status": "in_progress",
                                            "security_profile_name": "email-only",
                                            "security_code_length": 4,
                                            "allowed_login_attempts": 3,
                                            "allow_remember_me": false,
                                            "allow_sms": false,
                                            "allow_voice": false,
                                            "allow_email": true,
                                            "reply_enabled": true,
                                            "group_replies": false,
                                            "code_time_limit": 5,
                                            "encrypt_message": false,
                                            "two_factor_required": true,
                                            "auto_extend_value": 3,
                                            "auto_extend_unit": "days",
                                            "retention_period_type": "discard_at_expiration",
                                            "retention_period_value": nil,
                                            "retention_period_unit": nil,
                                            "delete_content_on": nil,
                                            "preview_url": "http://sendsecure.lvh.me:3001/s/5b8e88acc9c44b229ba64256298f9388/preview?k=AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                                            "encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                                            "created_at": "2016-12-05T22:38:09.965Z",
                                            "updated_at": "2016-12-05T22:38:09.965Z",
                                            "latest_activity": "2016-12-05T22:38:10.068Z",
                                            is_creation: true
                                          }) }

  let(:reply) {SendSecure::Reply.new({ "message": "Test reply message",
                                       "consent": true
                                      })}

  let(:message) {SendSecure::Message.new({ "id": 145926,
                                           "note": "Lorem Ipsum...",
                                           "note_size": 148,
                                           "read": true,
                                           "author_id": "3",
                                           "author_type": "guest",
                                           "created_at": "2017-04-05T14:49:35.198Z",
                                           "documents": []
                                          })}

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "reply" do

    it "return the result Hash" do
      response_body = { "result" => true,
                        "message" => "SafeBox successfully updated." }
      reply.attachments << SendSecure::Attachment.new({
                                          "file_path": Dir.pwd + "/spec/data/simple.pdf",
                                          "content_type": "application/pdf" })
      expect(client.json_client).to receive(:initialize_file).and_return({ "temporary_document_guid"=> "6c58a1335a3142d6b140c06003c45d58",
                                                                           "upload_url"=> "http://fileserver.lvh.me/xmss/DteeDmOcWbl96EVtI="})
      expect(client.json_client).to receive(:upload_file).and_return({ "temporary_document"=>{"document_guid"=>"5d4d6a8158b04915a532622983eb4493"} })
      expect(client.json_client).to receive(:reply).and_return(response_body)
      result = client.reply(safebox, reply)
      expect(result["result"]).to eq(true)
      expect(result["message"]).to eq("SafeBox successfully updated.")
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.reply(safebox, reply) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "add_time" do

    it "return the updated safebox" do
      response_body = { "result" => true,
                        "message" => "SafeBox duration successfully extended.",
                        "new_expiration" => "2016-15-06T05:38:09.951Z" }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:add_time).and_return(response_body)
      result = client.add_time(safebox, 3, SendSecure::SafeBox::TIME_UNIT[:hours])
      expect(result["message"]).to eq("SafeBox duration successfully extended.")
      expect(result["new_expiration"]).to be_nil
      expect(safebox.expiration).to eq("2016-15-06T05:38:09.951Z")
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.add_time(safebox, 3, "days") }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "close_safebox" do

    it "return the result hash" do
      response_body = { "result" => true,
                        "message" => "SafeBox successfully closed." }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:close_safebox).and_return(response_body)
      result = client.close_safebox(safebox)
      expect(result["result"]).to eq(true)
      expect(result["message"]).to eq("SafeBox successfully closed.")
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.close_safebox(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "delete_safebox_content" do

    it "return the result hash" do
      response_body = { "result" => true,
                        "message" => "SafeBox content successfully deleted." }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:delete_safebox_content).and_return(response_body)
      result = client.delete_safebox_content(safebox)
      expect(result["result"]).to eq(true)
      expect(result["message"]).to eq("SafeBox content successfully deleted.")
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.delete_safebox_content(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "mark_as_read" do

    it "return the result hash" do
      response_body = { "result" => true }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:mark_as_read).and_return(response_body)
      result = client.mark_as_read(safebox)
      expect(result["result"]).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.mark_as_read(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "mark_as_unread" do

    it "return the result hash" do
      response_body = { "result" => true }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:mark_as_unread).and_return(response_body)
      result = client.mark_as_unread(safebox)
      expect(result["result"]).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.mark_as_unread(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "mark_as_read_message" do

    it "return the result hash" do
      response_body = { "result" => true }
      expect(client.json_client).to receive(:mark_as_read_message).and_return(response_body)
      result = client.mark_as_read_message(safebox, message)
      expect(result["result"]).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.mark_as_read_message(safebox, message) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

    it "raises an exception when message is missing" do
      message = nil
      expect{ client.mark_as_read_message(safebox, message) }.to raise_error SendSecure::SendSecureException, "Message cannot be null"
    end

  end

  context "mark_as_unread_message" do

    it "return the result hash" do
      response_body = { "result" => true }
      expect(client.json_client).to receive(:mark_as_unread_message).and_return(response_body)
      result = client.mark_as_unread_message(safebox, message)
      expect(result["result"]).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.mark_as_unread_message(safebox, message) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

    it "raises an exception when message is missing" do
      message = nil
      expect{ client.mark_as_unread_message(safebox, message) }.to raise_error SendSecure::SendSecureException, "Message cannot be null"
    end

  end

  context "get_audit_record_pdf_url" do

    it "return the url" do
      response_body = { "url" => "http://sendsecure.integration.xmedius.com/s/07377f0e7296437bbfdb578576a799ac.pdf" }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_audit_record_pdf_url).and_return(response_body)
      result = client.get_audit_record_pdf_url(safebox)
      expect(result).to eql("http://sendsecure.integration.xmedius.com/s/07377f0e7296437bbfdb578576a799ac.pdf")
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.get_audit_record_pdf_url(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "get_safebox_info" do

    it "return the updated safebox" do
      response_body = { "safebox" => {
                          "guid" => "73af62f766ee459e81f46e4f533085a4",
                          "user_id" => 1,
                          "enterprise_id" => 1,
                          "participants" => [
                            { "id" => "7a3c51e00a004917a8f5db807180fcc5",
                              "guest_options" => {},
                              "message_read_count" => 0,
                              "message_total_count" => 1 },
                            { "id" => "1",
                              "first_name" => "Jane",
                              "last_name" => "Doe",
                              "email" => "jane.doe@example.com",
                              "type" => "user",
                              "role" => "owner",
                              "message_read_count" => 0,
                              "message_total_count" => 1 }
                          ],
                          "security_options" => {
                            "security_code_length": 4
                          },
                          "messages" => [
                            { "note" => "Lorem Ipsum...",
                              "note_size" => 123,
                              "documents" => [] }
                          ],
                          "download_activity" => {
                            "guests" => [
                              { "id" => "42220c777c30486e80cd3bbfa7f8e82f",
                                "documents" => [] }
                            ],
                            "owner" => {
                              "id" => 1,
                              "documents" => []
                            }
                          },
                          "event_history" => [
                            { "type" => "safebox_created_owner",
                              "date" => "2017-03-30T18:09:05.966Z",
                              "metadata" => {},
                              "message" => "SafeBox créée par laurence4815@gmail.com avec 0 pièce(s) jointe(s) depuis 192.168.0.1 pour john44@example.com" }
                          ]
                        }
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_safebox_info).and_return(response_body)
      result = client.get_safebox_info(safebox)
      expect(result.security_options.is_a?(SendSecure::SecurityOptions)).to eq(true)
      expect(result.participants[0].is_a?(SendSecure::Participant)).to eq(true)
      expect(result.download_activity.is_a?(SendSecure::DownloadActivity)).to eq(true)
      expect(result.messages[0].is_a?(SendSecure::Message)).to eq(true)
      expect(result.event_history[0].is_a?(SendSecure::EventHistory)).to eq(true)
      expect(result).to eq(safebox)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.get_safebox_info(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "get_safebox_participants" do

    it "return a list of participants" do
      response_body = { "participants" => [
                          { "id" => "7a3c51e00a004917a8f5db807180fcc5",
                            "first_name" => "John",
                            "last_name" => "Smith",
                            "email" => "john.smith@example.com",
                            "type" => "guest",
                            "role" => "guest",
                            "guest_options" => {
                              "company_name" => "Acme",
                              "locked" => false,
                              "bounced_email" => false,
                              "failed_login_attempts" => 0,
                              "verified" => false,
                              "contact_methods" => [
                                { "id" => 1,
                                  "destination" => "+15145550000",
                                  "destination_type" => "office_phone",
                                  "verified" => false,
                                  "created_at" => "2017-04-28T17:14:55.304Z",
                                  "updated_at" => "2017-04-28T17:14:55.304Z" }
                              ]
                            }
                          },
                          { "id" => "1",
                            "first_name" => "Jane",
                            "last_name" => "Doe",
                            "email" => "jane.doe@example.com",
                            "type" => "user",
                            "role" => "owner" }
                        ]
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_safebox_participants).and_return(response_body)
      result = client.get_safebox_participants(safebox)
      expect(result.size).to eq(2)
      expect(result[0].is_a?(SendSecure::Participant)).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.get_safebox_participants(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "get_safebox_messages" do

    it "return a list of messages" do
      response_body = { "messages" => [
                          { "note" => "Lorem Ipsum...",
                            "note_size" => 123,
                            "read" => true,
                            "author_id" => "1",
                            "author_type" => "guest",
                            "created_at" => "2017-04-05T14:49:35.198Z",
                            "documents" => [
                              { "id" => "5a3df276aaa24e43af5aca9b2204a535",
                                "name" => "Axient-soapui-project.xml",
                                "sha" => "724ae04430315c60ca17f4dbee775a37f5b18c91fde6eef24f77a605aee99c9c",
                                "size" => 12345,
                                "url" => "https://sendsecure.integration.xmedius.com/api/v2/safeboxes/b4d898ada15f42f293e31905c514607f/documents/5a3df276aaa24e43af5aca9b2204a535/url" }
                            ]
                          }
                        ]
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_safebox_messages).and_return(response_body)
      result = client.get_safebox_messages(safebox)
      expect(result.size).to eq(1)
      expect(result[0].is_a?(SendSecure::Message)).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.get_safebox_messages(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "get_safebox_event_history" do

    it "return a list of event history" do
      response_body = { "event_history" => [
                          { "type" => "safebox_created_owner",
                            "date" => "2017-03-30T18:09:05.966Z",
                            "metadata" => {
                              "emails" => [
                                "john44@example.com"
                              ],
                              "attachment_count" => 0
                            },
                            "message" => "SafeBox créée par laurence4815@gmail.com avec 0 pièce(s) jointe(s) depuis 192.168.0.1 pour john44@example.com" }
                        ]
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_safebox_event_history).and_return(response_body)
      result = client.get_safebox_event_history(safebox)
      expect(result.size).to eq(1)
      expect(result[0].is_a?(SendSecure::EventHistory)).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.get_safebox_event_history(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "get_safebox_security_options" do

    it "return the security options" do
      response_body = { "security_options" => {
                          "security_code_length" => 4,
                          "code_time_limit" => 5,
                          "allowed_login_attempts" => 3,
                          "allow_remember_me" => true,
                          "allow_sms" => true,
                          "allow_voice" => true,
                          "allow_email" => false,
                          "reply_enabled" => true,
                          "group_replies" => false,
                          "expiration_value" => 5,
                          "expiration_unit" => "days",
                          "retention_period_type" => "do_not_discard",
                          "retention_period_value" => nil,
                          "retention_period_unit" => "hours",
                          "encrypt_message" => true,
                          "double_encryption" => true,
                          "two_factor_required" => true,
                          "auto_extend_value" => 3,
                          "auto_extend_unit" => "days",
                          "delete_content_on" => nil,
                          "allow_manual_delete" => true,
                          "allow_manual_close" => false,
                        }
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_safebox_security_options).and_return(response_body)
      result = client.get_safebox_security_options(safebox)
      expect(result.is_a?(SendSecure::SecurityOptions)).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.get_safebox_security_options(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "get_safebox_download_activity" do

    it "return the security options" do
      response_body = { "download_activity" => {
                          "guests" => [
                            { "id" => "42220c777c30486e80cd3bbfa7f8e82f",
                              "documents" => [
                                { "id" => "5a3df276aaa24e43af5aca9b2204a535",
                                  "downloaded_bytes" => 0,
                                  "download_date"=> nil }
                              ]
                            }
                          ],
                          "owner" => {
                            "id" => 1,
                            "documents" => []
                          }
                        }
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_safebox_download_activity).and_return(response_body)
      result = client.get_safebox_download_activity(safebox)
      expect(result.is_a?(SendSecure::DownloadActivity)).to eq(true)
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.get_safebox_download_activity(safebox) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

end