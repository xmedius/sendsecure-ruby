require 'spec_helper'

describe SendSecure::ClientMethods::DocumentMethods do
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

  context "get_file_url" do

    it "return the result hash" do
      response_body = { "url" => "https://fileserver.integration.xmedius.com/xmss/DteeDmb-2zfN5WtCbgpJfSENaNjvbHi_ntxetJTunCisYYoBaqOQgg0Bhxsj3f-tLqsqDqTkI6agm1iaCDLQUM4otT27YqbjAsX3SawP0vIXfFqB-Ginnw6xYzk8do8KFb-SElCdo6C5PcF-QCD2OQRa12ukN7ifuHw42-_TX-sgXjv381sswHwtkKgXdIly4cq6QUXKRg-Q7_0THC9CmoJdqr2iVHe1xOi2VOI68BfNO5o6yKuBZ-zrMpwSf6wDcDuBhQnzGk3Si04UrhIJ7gG3ZpwccB0MDJ0HayMO_avlrlALpPrs8g1UcYu4UGgFJO406ab0GI_XoqUXxK8El0lPuw52qJzVOIp_uQ1WaOpZChu-i9C4SWgnlG8XOfN3ypQHmYgtUtAuY4pkiYusPFCyPwhmWeGihlACt-9b2YERjsWPQ2xfAALGEeumfOllVfS324IOlGJQ1UWagvX7_utR-9rAmTFTjwDa62ZBTcteQhSLuRpqJ4q2BkCYDRXP" }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:get_file_url).and_return(response_body)
      result = client.get_file_url(safebox, SendSecure::Attachment.new({guid: "5d4d6a8158b04915a532622983eb4493"}))
      expect(result).to eq("https://fileserver.integration.xmedius.com/xmss/DteeDmb-2zfN5WtCbgpJfSENaNjvbHi_ntxetJTunCisYYoBaqOQgg0Bhxsj3f-tLqsqDqTkI6agm1iaCDLQUM4otT27YqbjAsX3SawP0vIXfFqB-Ginnw6xYzk8do8KFb-SElCdo6C5PcF-QCD2OQRa12ukN7ifuHw42-_TX-sgXjv381sswHwtkKgXdIly4cq6QUXKRg-Q7_0THC9CmoJdqr2iVHe1xOi2VOI68BfNO5o6yKuBZ-zrMpwSf6wDcDuBhQnzGk3Si04UrhIJ7gG3ZpwccB0MDJ0HayMO_avlrlALpPrs8g1UcYu4UGgFJO406ab0GI_XoqUXxK8El0lPuw52qJzVOIp_uQ1WaOpZChu-i9C4SWgnlG8XOfN3ypQHmYgtUtAuY4pkiYusPFCyPwhmWeGihlACt-9b2YERjsWPQ2xfAALGEeumfOllVfS324IOlGJQ1UWagvX7_utR-9rAmTFTjwDa62ZBTcteQhSLuRpqJ4q2BkCYDRXP")
    end

    it "raises an exception when safebox guid is missing" do
      safebox.guid = nil
      expect{ client.get_file_url(safebox, SendSecure::Attachment.new({guid: "5d4d6a8158b04915a532622983eb4493"})) }.to raise_error SendSecure::SendSecureException, "SafeBox GUID cannot be null"
    end

    it "raises an exception when user email is missing" do
      safebox.user_email = nil
      expect{ client.get_file_url(safebox, SendSecure::Attachment.new({guid: "5d4d6a8158b04915a532622983eb4493"})) }.to raise_error SendSecure::SendSecureException, "SafeBox user email cannot be null"
    end

    it "raises an exception when document guid is missing" do
      expect{ client.get_file_url(safebox, SendSecure::Attachment.new({guid: nil})) }.to raise_error SendSecure::SendSecureException, "Document GUID cannot be null"
    end

  end

end