require 'spec_helper'

describe SendSecure::ClientMethods::ParticipantMethods do
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

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end


  context "create_participant" do
    let(:participant) { SendSecure::Participant.new({ "first_name": "John",
                                                      "last_name": "Smith",
                                                      "email": "john.smith@example.com",
                                                      "guest_options": {
                                                        "company_name": "Acme",
                                                        "contact_methods": [
                                                          { "destination": "+15145550000",
                                                            "destination_type": "office_phone"},
                                                          { "destination": "+15145550001",
                                                            "destination_type": "cell_phone" }
                                                        ]
                                                      }
                                                    }) }
    let(:response_body) { { "id" => "7a3c51e00a004917a8f5db807180fcc5",
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
                                  "updated_at" => "2017-04-28T17:14:55.304Z" },
                                { "id" => 2,
                                  "destination" => "+15145550001",
                                  "destination_type" => "cell_phone",
                                  "verified" => true,
                                  "created_at" => "2017-04-28T18:14:55.304Z",
                                  "updated_at" => "2017-04-28T18:14:55.304Z" }
                              ]
                            }
                          } }

    it "return the updated participant" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:create_participant).and_return(response_body)
      result = client.create_participant(safebox, participant)
      expect(result.is_a?(SendSecure::Participant)).to eq(true)
      expect(result.id).to eq("7a3c51e00a004917a8f5db807180fcc5")
    end

    it "add the participant to the safebox object" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:create_participant).and_return(response_body)
      result = client.create_participant(safebox, participant)
      expect(safebox.participants).to include(result)
    end

    it "raises an exception when participant email is missing" do
      participant.email = nil
      expect{ client.create_participant(safebox, participant) }.to raise_error SendSecure::SendSecureException, "Participant email cannot be null"
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.create_participant(safebox, participant) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "update_participant" do
    let(:participant) { safebox.participants[0] }

    it "return the updated participant" do
      response_body = { "id" => "7a3c51e00a004917a8f5db807180fcc5",
                        "first_name" => "John",
                        "last_name" => "Smith",
                        "email" => "recipient@test.xmedius.com",
                        "type" => "guest",
                        "role" => "guest",
                        "guest_options" => {
                          "company_name" => "",
                          "locked" => true,
                          "bounced_email" => false,
                          "failed_login_attempts" => 0,
                          "verified" => false,
                          "contact_methods" => [
                            { "id" => 1,
                              "destination" => "+15145550000",
                              "destination_type" => "cell_phone",
                              "verified" => false,
                              "created_at" => "2017-04-28T17:14:55.304Z",
                              "updated_at" => "2017-04-28T17:14:55.304Z" }
                          ]
                        }
                      }

      participant.update_attributes({ "id": "7a3c51e00a004917a8f5db807180fcc5",
                                      "first_name": "John",
                                      "last_name": "Smith",
                                      "guest_options": {
                                        "locked": true
                                    }})

      allow_any_instance_of(SendSecure::JsonClient).to receive(:update_participant).and_return(response_body)
      result = client.update_participant(safebox, participant)
      expect(result.email).to eq("recipient@test.xmedius.com")
      expect(result.first_name).to eq(participant.first_name)
    end

    it "raises an exception when participant id is missing" do
      expect{ client.update_participant(safebox, participant) }.to raise_error SendSecure::SendSecureException, "Participant id cannot be null"
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.update_participant(safebox, participant) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

  context "delete_participant_contact_methods" do
    let(:participant) { safebox.participants[0] }

    it "contact method is correctly deleted" do
      response_body = { "id" => "7a3c51e00a004917a8f5db807180fcc5",
                        "first_name" => "John",
                        "last_name" => "Smith",
                        "email" => "recipient@test.xmedius.com",
                        "type" => "guest",
                        "role" => "guest",
                        "guest_options" => {
                          "company_name" => "",
                          "locked" => true,
                          "bounced_email" => false,
                          "failed_login_attempts" => 0,
                          "verified" => false,
                          "contact_methods" => []
                        }
                      }

      participant.update_attributes({ "id": "7a3c51e00a004917a8f5db807180fcc5",
                                      "first_name": "John",
                                      "last_name": "Smith",
                                      "guest_options": {
                                        "locked": true,
                                        "contact_methods": [
                                          { "id": 1,
                                            "destination": "+15145550000",
                                            "destination_type": "cell_phone" }
                                        ]
                                      }
                                    })

      allow_any_instance_of(SendSecure::JsonClient).to receive(:update_participant).and_return(response_body)
      result = client.delete_participant_contact_methods(safebox, participant, [1])
      expect(result.is_a?(SendSecure::Participant)).to eq(true)
      expect(result.email).to eq("recipient@test.xmedius.com")
      expect(result.guest_options.contact_methods).to be_empty
    end

    it "raises an exception when participant id is missing" do
      expect{ client.delete_participant_contact_methods(safebox, participant, [1]) }.to raise_error SendSecure::SendSecureException, "Participant id cannot be null"
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.delete_participant_contact_methods(safebox, participant, [1]) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

  end

end