require 'spec_helper'

describe SendSecure::JsonMethods::EnterpriseMethods do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "security_profiles" do

    it "return security_profiles on success" do
      response_body = { "security_profiles"=>[
                          { "id"=>5 },
                          { "id"=>10 }
                        ]
                      }
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/security_profiles.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.security_profiles("user@acme.com")
      expect(result["security_profiles"].size).to eq(2)
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/security_profiles.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.security_profiles("invalid_user@acme.com") }.to raise_error SendSecure::SendSecureException, "Access denied"
    end

  end

  context "enterprise_setting" do

    it "return enterprise_setting on success" do
      response_body = { "created_at" => "2016-03-15T19:58:11.588Z",
                        "updated_at" => "2016-09-28T18:32:16.643Z",
                        "default_security_profile_id" => 10 }
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/settings.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.enterprise_setting
      expect(result["default_security_profile_id"]).to eq(10)
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/settings.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.enterprise_setting }.to raise_error SendSecure::SendSecureException, "Access denied"
    end

  end

end