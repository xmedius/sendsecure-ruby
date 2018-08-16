require 'spec_helper'

describe SendSecure::JsonMethods::SafeboxOperations do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }
  let(:safebox_guid) { "73af62f766ee459e81f46e4f533085a4" }
  let(:message_id) {"145926"}

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "create_participant" do
    let(:participant_params) {{ "participant": {
                                    "first_name": "John",
                                    "last_name": "Smith",
                                    "company_name": "Acme",
                                    "email": "john.smith@example.com",
                                    "contact_methods": [
                                      { "destination": "+15145550000",
                                        "destination_type": "office_phone" }
                                    ]
                                  }
                              }}

    it "return participant on success" do
      response_body = { "id" => "7a3c51e00a004917a8f5db807180fcc5",
                        "type" => "guest",
                        "guest_options" => {
                          "company_name" => "Acme",
                          "contact_methods" => [
                            { "id"=>1,
                              "created_at"=>"2017-04-28T17:14:55.304Z" }
                          ]
                        }
                      }

      sendsecure_connection do |stubs|
        stubs.post("api/v2/safeboxes/#{safebox_guid}/participants.json", participant_params) { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.create_participant(safebox_guid, participant_params)
      expect(result.has_key?("id")).to be true
      expect(result.has_key?("type")).to be true
      expect(result.has_key?("guest_options")).to be true
      expect(result["guest_options"]["contact_methods"][0].has_key?("created_at")).to be true
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.post("api/v2/safeboxes/#{safebox_guid}/participants.json", participant_params) { |env| [ 400, {}, ({"error"=>"Some entered values are incorrect.", "attributes"=>{"email"=>["cannot be blank"]}}).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.create_participant(safebox_guid, participant_params) }.to raise_error SendSecure::SendSecureException, "Some entered values are incorrect. {\"email\"=>[\"cannot be blank\"]}"
    end

  end

  context "update_participant" do
    let(:participant_params) {{ "participant": {
                                  "first_name": "John",
                                  "last_name": "Smith",
                                  "company_name": "Acme",
                                  "locked": true,
                                  "contact_methods": [
                                    { "id": 1,
                                      "destination": "+15145550000",
                                      "destination_type": "office_phone" }
                                  ]
                                }
                              }}

    let(:participant_id) { "7a3c51e00a004917a8f5db807180fcc5" }

    it "return participant on success" do
      response_body = { "id" => participant_id,
                        "email" => "john.smith@example.com",
                        "type" => "guest",
                        "guest_options" => {
                          "company_name" => "Acme",
                          "contact_methods" => [
                            { "id"=>1,
                              "created_at"=>"2017-04-28T17:14:55.304Z" }
                          ]
                        }
                      }

      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/participants/#{participant_id}.json", participant_params) { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.update_participant(safebox_guid, participant_id, participant_params)
      expect(result.has_key?("id")).to be true
      expect(result.has_key?("type")).to be true
      expect(result.has_key?("email")).to be true
      expect(result.has_key?("guest_options")).to be true
      expect(result["guest_options"]["contact_methods"][0].has_key?("created_at")).to be true
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/participants/#{participant_id}.json", participant_params) { |env| [ 400, {}, ({"error"=>"Some entered values are incorrect.", "attributes"=>{"contact_methods"=>["cannot be blank"]}}).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.update_participant(safebox_guid, participant_id, participant_params) }.to raise_error SendSecure::SendSecureException, "Some entered values are incorrect. {\"contact_methods\"=>[\"cannot be blank\"]}"
    end

  end

  context "reply" do
    let(:reply_params) { { "safebox": {
                              "message": "Test reply message",
                              "consent": true,
                              "document_ids": ["1c820789a50747df8746aa5d71922a3f"]
                            }
                          } }

    it "return result on success" do
      response_body = { "result" => true,
                        "message" => "SafeBox successfully updated." }

      sendsecure_connection do |stubs|
        stubs.post("api/v2/safeboxes/#{safebox_guid}/messages.json", reply_params) { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.reply(safebox_guid, reply_params)
      expect(result["result"]).to eq(true)
      expect(result["message"]).to eq("SafeBox successfully updated.")
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.post("api/v2/safeboxes/#{safebox_guid}/messages.json", reply_params) { |env| [ 400, {}, ({ result: false, message: "Unable to extend the SafeBox duration." }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.reply(safebox_guid, reply_params) }.to raise_error SendSecure::SendSecureException, "Unable to extend the SafeBox duration."
    end

  end

  context "add_time" do
    let(:add_time_params) { { "safebox": {
                                "add_time_value": 2,
                                "add_time_unit": "weeks"
                              }
                            } }

    it "return expiration on success" do
      response_body = { "result" => true,
                        "message" => "SafeBox duration successfully extended.",
                        "new_expiration" => "2017-05-14T18:09:05.662Z" }

      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/add_time.json", add_time_params) { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.add_time(safebox_guid, add_time_params)
      expect(result["result"]).to eq(true)
      expect(result["message"]).to eq("SafeBox duration successfully extended.")
      expect(result["new_expiration"]).to eq("2017-05-14T18:09:05.662Z")
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/add_time.json", add_time_params) { |env| [ 400, {}, ({ result: false, message: "Unable to extend the SafeBox duration." }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.add_time(safebox_guid, add_time_params) }.to raise_error SendSecure::SendSecureException, "Unable to extend the SafeBox duration."
    end

  end

  context "close_safebox" do

    it "return result on success" do
      response_body = { "result" => true,
                        "message" => "SafeBox successfully closed." }

      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/close.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.close_safebox(safebox_guid)
      expect(result["result"]).to eq(true)
      expect(result["message"]).to eq("SafeBox successfully closed.")
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/close.json") { |env| [ 400, {}, ({ result: false, message: "Unable to close the SafeBox." }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.close_safebox(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Unable to close the SafeBox."
    end

  end

  context "delete_safebox_content" do

    it "return result on success" do
      response_body = { "result" => true,
                        "message" => "SafeBox content successfully deleted." }

      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/delete_content.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.delete_safebox_content(safebox_guid)
      expect(result["result"]).to eq(true)
      expect(result["message"]).to eq("SafeBox content successfully deleted.")
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/delete_content.json") { |env| [ 400, {}, ({ result: false, message: "Unable to delete the SafeBox content." }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.delete_safebox_content(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Unable to delete the SafeBox content."
    end

  end

  context "mark_as_read" do

    it "return result on success" do
      response_body = { "result" => true }
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/mark_as_read.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.mark_as_read(safebox_guid)
      expect(result["result"]).to eq(true)
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/mark_as_read.json") { |env| [ 400, {}, ({ result: false, message: "Unable to mark the SafeBox as Read." }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.mark_as_read(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Unable to mark the SafeBox as Read."
    end

  end

  context "mark_as_unread" do

    it "return result on success" do
      response_body = { "result" => true }
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/mark_as_unread.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.mark_as_unread(safebox_guid)
      expect(result["result"]).to eq(true)
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/mark_as_unread.json") { |env| [ 400, {}, ({ result: false, message: "Unable to mark the SafeBox as Unread." }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.mark_as_unread(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Unable to mark the SafeBox as Unread."
    end

  end

  context "mark_as_read_message" do

    it "return result on success" do
      response_body = { "result" => true }
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/messages/#{message_id}/read") { |env| [ 200, {}, response_body ]}
      end
      expect(client).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.mark_as_read_message(safebox_guid, message_id)
      expect(result["result"]).to eq(true)
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/messages/#{message_id}/read") { |env| [ 400, {}, ({ result: false, message: "Unable to mark the message as read." }).to_json ]}
      end
      expect(client).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.mark_as_read_message(safebox_guid, message_id) }.to raise_error SendSecure::SendSecureException, "Unable to mark the message as read."
    end

  end

  context "mark_as_unread_message" do

    it "return result on success" do
      response_body = { "result" => true }
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/messages/#{message_id}/unread") { |env| [ 200, {}, response_body ]}
      end
      expect(client).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.mark_as_unread_message(safebox_guid, message_id)
      expect(result["result"]).to eq(true)
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/#{safebox_guid}/messages/#{message_id}/unread") { |env| [ 400, {}, ({ result: false, message: "Unable to mark the message as unread." }).to_json ]}
      end
      expect(client).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.mark_as_unread_message(safebox_guid, message_id) }.to raise_error SendSecure::SendSecureException, "Unable to mark the message as unread."
    end

  end

  context "get_file_url" do
    let(:document_guid) { "87dcf118072841e6ad50e2feeda2c61c" }

    it "return file url on success" do
      response_body = { "url" => "https://fileserver.integration.xmedius.com/xmss/DteeDmb-2zfN5WtCbgpJfSENaNjvbHi_ntxetJTunCisYYoBaqOQgg0Bhxsj3f-tLqsqDqTkI6agm1iaCDLQUM4otT27YqbjAsX3SawP0vIXfFqB-Ginnw6xYzk8do8KFb-SElCdo6C5PcF-QCD2OQRa12ukN7ifuHw42-_TX-sgXjv381sswHwtkKgXdIly4cq6QUXKRg-Q7_0THC9CmoJdqr2iVHe1xOi2VOI68BfNO5o6yKuBZ-zrMpwSf6wDcDuBhQnzGk3Si04UrhIJ7gG3ZpwccB0MDJ0HayMO_avlrlALpPrs8g1UcYu4UGgFJO406ab0GI_XoqUXxK8El0lPuw52qJzVOIp_uQ1WaOpZChu-i9C4SWgnlG8XOfN3ypQHmYgtUtAuY4pkiYusPFCyPwhmWeGihlACt-9b2YERjsWPQ2xfAALGEeumfOllVfS324IOlGJQ1UWagvX7_utR-9rAmTFTjwDa62ZBTcteQhSLuRpqJ4q2BkCYDRXP" }
      sendsecure_connection do |stubs|
        stubs.get("api/v2/safeboxes/#{safebox_guid}/documents/#{document_guid}/url.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.get_file_url(safebox_guid, document_guid, "john.smith@example.com")
      expect(result["url"]).to eq("https://fileserver.integration.xmedius.com/xmss/DteeDmb-2zfN5WtCbgpJfSENaNjvbHi_ntxetJTunCisYYoBaqOQgg0Bhxsj3f-tLqsqDqTkI6agm1iaCDLQUM4otT27YqbjAsX3SawP0vIXfFqB-Ginnw6xYzk8do8KFb-SElCdo6C5PcF-QCD2OQRa12ukN7ifuHw42-_TX-sgXjv381sswHwtkKgXdIly4cq6QUXKRg-Q7_0THC9CmoJdqr2iVHe1xOi2VOI68BfNO5o6yKuBZ-zrMpwSf6wDcDuBhQnzGk3Si04UrhIJ7gG3ZpwccB0MDJ0HayMO_avlrlALpPrs8g1UcYu4UGgFJO406ab0GI_XoqUXxK8El0lPuw52qJzVOIp_uQ1WaOpZChu-i9C4SWgnlG8XOfN3ypQHmYgtUtAuY4pkiYusPFCyPwhmWeGihlACt-9b2YERjsWPQ2xfAALGEeumfOllVfS324IOlGJQ1UWagvX7_utR-9rAmTFTjwDa62ZBTcteQhSLuRpqJ4q2BkCYDRXP")
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/safeboxes/#{safebox_guid}/documents/#{document_guid}/url.json") { |env| [ 400, {}, ({ "error"=>"User email not found" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.get_file_url(safebox_guid, document_guid, "invalid_user@example.com") }.to raise_error SendSecure::SendSecureException, "User email not found"
    end

  end

  context "get_audit_record_pdf_url" do

    it "return pdf url on success" do
      response_body = { "url" => "http://sendsecure.integration.xmedius.com/s/73af62f766ee459e81f46e4f533085a4.pdf" }
      sendsecure_connection do |stubs|
        stubs.get("api/v2/safeboxes/#{safebox_guid}/audit_record_pdf.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.get_audit_record_pdf_url(safebox_guid)
      expect(result["url"]).to eq("http://sendsecure.integration.xmedius.com/s/73af62f766ee459e81f46e4f533085a4.pdf")
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/safeboxes/#{safebox_guid}/audit_record_pdf.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.get_audit_record_pdf_url(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Access denied"
    end

  end

end