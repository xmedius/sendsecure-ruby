require 'spec_helper'

describe SendSecure::ClientMethods::EnterpriseMethods do
  let(:client) { SendSecure::Client.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "security_profiles" do

    it "return list of security profiles" do
      response_body = { "security_profiles" => [
                          { "id" => 5,
                            "name" => "reply",
                            "description" => "no email",
                            "created_at" => "2016-04-19T16:26:18.277Z",
                            "updated_at" => "2016-09-07T19:33:51.192Z",
                            "allowed_login_attempts" => {
                              "value" => 3,
                              "modifiable" => false
                            } },
                          { "id" => 10,
                            "name" => "email-only",
                            "description" => "",
                            "created_at" => "2016-04-27T21:08:29.457Z",
                            "updated_at" => "2016-07-27T19:03:05.883Z",
                            "allow_remember_me" => {
                              "value" => false,
                              "modifiable" => false
                            } }
                        ]
                      }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:security_profiles).and_return(response_body)
      result = client.security_profiles("user@acme.com")
      expect(result.size).to eq(2)
      expect(result[0].is_a?(SendSecure::SecurityProfile)).to eq(true)
      expect(result[0].allowed_login_attempts.is_a?(SendSecure::Value)).to eq(true)
      expect(result[0].allowed_login_attempts.value).to eq(3)
    end
  end

  context "enterprise_settings" do

    it "return enterprise_setting" do
      response_body = { "created_at" => "2016-03-15T19:58:11.588Z",
                        "updated_at" => "2016-09-28T18:32:16.643Z",
                        "default_security_profile_id" => 10,
                        "pdf_language" => "fr",
                        "use_pdfa_audit_records" => false,
                        "international_dialing_plan" => "us",
                        "extension_filter" => {
                          "mode" => "forbid",
                          "list" => []
                        },
                        "include_users_in_autocomplete" => true,
                        "include_favorites_in_autocomplete" => true
                      }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:enterprise_setting).and_return(response_body)
      result = client.enterprise_settings
      expect(result.is_a?(SendSecure::EnterpriseSetting)).to eq(true)
      expect(result.default_security_profile_id).to eq(10)
    end
  end

  context "default_security_profile" do

    it "return default_security_profile" do
      enterprise_setting_response = { "created_at" => "2016-03-15T19:58:11.588Z",
                                      "updated_at" => "2016-09-28T18:32:16.643Z",
                                      "default_security_profile_id" => 10,
                                      "pdf_language" => "fr",
                                      "use_pdfa_audit_records" => false,
                                      "international_dialing_plan" => "us",
                                      "extension_filter" => {
                                        "mode" => "forbid",
                                        "list" => []
                                      },
                                      "include_users_in_autocomplete" => true,
                                      "include_favorites_in_autocomplete" => true
                                    }
      security_profiles_response =  { "security_profiles" => [
                                        { "id" => 5,
                                          "name" => "reply",
                                          "description" => "no email",
                                          "created_at" => "2016-04-19T16:26:18.277Z",
                                          "updated_at" => "2016-09-07T19:33:51.192Z",
                                          "allowed_login_attempts" => {
                                            "value" => 3,
                                            "modifiable" => false
                                          } },
                                        { "id" => 10,
                                          "name" => "email-only",
                                          "description" => "",
                                          "created_at" => "2016-04-27T21:08:29.457Z",
                                          "updated_at" => "2016-07-27T19:03:05.883Z",
                                          "allow_remember_me" => {
                                            "value" => false,
                                            "modifiable" => false
                                          } }
                                      ]
                                    }
      allow_any_instance_of(SendSecure::JsonClient).to receive(:security_profiles).and_return(security_profiles_response)
      allow_any_instance_of(SendSecure::JsonClient).to receive(:enterprise_setting).and_return(enterprise_setting_response)
      result = client.default_security_profile("user@acme.com")
      expect(result.is_a?(SendSecure::SecurityProfile)).to eq(true)
      expect(result.id).to eq(10)
    end
  end

end
