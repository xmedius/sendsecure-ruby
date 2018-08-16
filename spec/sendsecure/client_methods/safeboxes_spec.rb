require 'spec_helper'

describe SendSecure::ClientMethods::SafeBoxes do
  let(:client) { SendSecure::Client.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "get_safebox_list" do
    let(:response_body) {{"count" => 2,
                          "previous_page_url" => nil,
                          "next_page_url" => "api/v2/safeboxes?status=unread&search=test&page=2",
                          "safeboxes" => [
                            { "safebox" => {
                                "guid" => "b9c6307bcc214799928e258633f8b6e74f",
                                "user_id" => 1,
                                "enterprise_id" => 1,
                                "subject" => "Donec rutrum congue leo eget malesuada. ",
                                "notification_language" => "de",
                                "status" => "in_progress",
                                "security_profile_name" => "All Contact Method Allowed!",
                                "unread_count" => 0,
                                "double_encryption_status" => "disabled",
                                "audit_record_pdf" => nil,
                                "secure_link" => nil,
                                "secure_link_title" => nil,
                                "email_notification_enabled" => true,
                                "created_at" => "2017-05-24T14:45:35.062Z",
                                "updated_at" => "2017-05-24T14:45:35.589Z",
                                "assigned_at" => "2017-05-24T14:45:35.040Z",
                                "latest_activity" => "2017-05-24T14:45:35.544Z",
                                "expiration" => "2017-05-31T14:45:35.038Z",
                                "closed_at" => nil,
                                "content_deleted_at" => nil
                              }
                            },
                            { "safebox" => {
                                "guid" => "73af62f766ee459e81f46e4f533085a4",
                                "user_id" => 1,
                                "enterprise_id" => 1,
                                "subject" => "Donec rutrum congue leo eget malesuada. ",
                                "notification_language" => "de",
                                "status" => "in_progress",
                                "security_profile_name" => "All Contact Method Allowed!",
                                "unread_count" => 0,
                                "double_encryption_status" => "disabled",
                                "audit_record_pdf" => nil,
                                "secure_link" => nil,
                                "secure_link_title" => nil,
                                "email_notification_enabled" => true,
                                "created_at" => "2017-05-24T14:45:35.062Z",
                                "updated_at" => "2017-05-24T14:45:35.589Z",
                                "assigned_at" => "2017-05-24T14:45:35.040Z",
                                "latest_activity" => "2017-05-24T14:45:35.544Z",
                                "expiration" => "2017-05-31T14:45:35.038Z",
                                "closed_at" => nil,
                                "content_deleted_at" => nil
                              }
                            }
                          ]
                        }}

    it "return informations about the found safeboxes" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_safebox_list).and_return(response_body)
      result = client.get_safebox_list(url: "api/v2/safeboxes?status=unread&search=test&page=1")
      expect(result["count"]).to eq(2)
      expect(result["previous_page_url"]).to be_nil
      expect(result["next_page_url"]).to eq("api/v2/safeboxes?status=unread&search=test&page=2")
    end

    it "return the list of safeboxes" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_safebox_list).and_return(response_body)
      result = client.get_safebox_list(url: "api/v2/safeboxes?status=unread&search=test&page=1")
      expect(result["safeboxes"].size).to eq(2)
      expect(result["safeboxes"][0].is_a?(SendSecure::SafeBox)).to eq(true)
    end

  end

  context "get_safebox" do
    let(:response_body) {{"count" => 2,
                          "previous_page_url" => nil,
                          "next_page_url" => "api/v2/safeboxes?status=unread&search=test&page=2",
                          "safeboxes" => [
                            { "safebox" => {
                                "guid" => "b9c6307bcc214799928e258633f8b6e74f",
                                "user_id" => 1,
                                "enterprise_id" => 1,
                                "subject" => "Donec rutrum congue leo eget malesuada. ",
                                "notification_language" => "de",
                                "status" => "in_progress",
                                "security_profile_name" => "All Contact Method Allowed!",
                                "unread_count" => 0,
                                "double_encryption_status" => "disabled",
                                "audit_record_pdf" => nil,
                                "secure_link" => nil,
                                "secure_link_title" => nil,
                                "email_notification_enabled" => true,
                                "created_at" => "2017-05-24T14:45:35.062Z",
                                "updated_at" => "2017-05-24T14:45:35.589Z",
                                "assigned_at" => "2017-05-24T14:45:35.040Z",
                                "latest_activity" => "2017-05-24T14:45:35.544Z",
                                "expiration" => "2017-05-31T14:45:35.038Z",
                                "closed_at" => nil,
                                "content_deleted_at" => nil
                              }
                            },
                            { "safebox" => {
                                "guid" => "73af62f766ee459e81f46e4f533085a4",
                                "user_id" => 1,
                                "enterprise_id" => 1,
                                "subject" => "Donec rutrum congue leo eget malesuada. ",
                                "notification_language" => "de",
                                "status" => "in_progress",
                                "security_profile_name" => "All Contact Method Allowed!",
                                "unread_count" => 0,
                                "double_encryption_status" => "disabled",
                                "audit_record_pdf" => nil,
                                "secure_link" => nil,
                                "secure_link_title" => nil,
                                "email_notification_enabled" => true,
                                "created_at" => "2017-05-24T14:45:35.062Z",
                                "updated_at" => "2017-05-24T14:45:35.589Z",
                                "assigned_at" => "2017-05-24T14:45:35.040Z",
                                "latest_activity" => "2017-05-24T14:45:35.544Z",
                                "expiration" => "2017-05-31T14:45:35.038Z",
                                "closed_at" => nil,
                                "content_deleted_at" => nil
                              }
                            }
                          ]
                        }}

    it "return the safebox" do
      expect(client.json_client).to receive(:get_safebox_list).and_return(response_body)
      result = client.get_safebox("73af62f766ee459e81f46e4f533085a4")
      expect(result.is_a?(SendSecure::SafeBox)).to be true
      expect(result.guid).to eq("73af62f766ee459e81f46e4f533085a4")
    end
  end

end