require 'spec_helper'

describe SendSecure::JsonClient do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "get_user_token" do

    it "return token on success" do
      response = Faraday::Response.new()
      response.finish({status: 200, response_headers:{}, body: ({ result: true, token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", user_id: 123 }).to_json })
      allow(Faraday).to receive(:post).and_return(response)
      options = {enterprise_account: "acme", username: "username", password: "password", device_id: "device_id", device_name: "device_name"}
      expect(SendSecure::JsonClient.get_user_token(options)).to eq({"result"=> true, "token"=> "USER|489b3b1f-b411-428e-be5b-2abbace87689", "user_id"=> 123})
    end

    it "raise exception on failure" do
      response = Faraday::Response.new()
      response.finish({status: 401, response_headers:{}, body: ({result:false, message:"invalid credentials", code:102}).to_json })
      allow(Faraday).to receive(:post).and_return(response)
      options = {enterprise_account: "acme", username: "invalid_username", password: "password", device_id: "device_id", device_name: "device_name"}
      expect { SendSecure::JsonClient.get_user_token(options) }.to raise_error SendSecure::SendSecureException, "invalid credentials"
    end

    it "raise exception when ressource is not found" do
      allow(Faraday).to receive(:post).and_raise(Faraday::Error::ResourceNotFound, "not found")
      options = {enterprise_account: "acme", username: "invalid_username", password: "password", device_id: "device_id", device_name: "device_name"}
      expect { SendSecure::JsonClient.get_user_token(options) }.to raise_error SendSecure::SendSecureException, "not found"
    end

    it "raise exception with error on Faraday" do
      allow(Faraday).to receive(:post).and_raise(Faraday::Error, "Problems with Faraday")
      options = {enterprise_account: "acme", username: "invalid_username", password: "password", device_id: "device_id", device_name: "device_name"}
      expect { SendSecure::JsonClient.get_user_token(options) }.to raise_error SendSecure::SendSecureException, "Problems with Faraday"
    end

    it "raise exception with error on response" do
      allow(JSON).to receive(:parse).and_raise(JSON::ParserError, "JSON::ParserError")
      options = {enterprise_account: "acme", username: "invalid_username", password: "password", device_id: "device_id", device_name: "device_name"}
      expect { SendSecure::JsonClient.get_user_token(options) }.to raise_error SendSecure::UnexpectedServerResponseException, "unexpected server response format"
    end

  end

  context "handle_error" do

    it "raise exception when json response is not parsable" do
      sendsecure_connection do |stubs|
        stubs.patch("api/v2/safeboxes/1/mark_as_unread.json") { |env| [ 400, {}, 123 ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      allow_any_instance_of(JSON).to receive(:parse).and_raise(JSON::ParserError, "JSON::ParserError")
      expect{ client.mark_as_unread(1) }.to raise_error SendSecure::UnexpectedServerResponseException, "unexpected server response format"
    end

  end

  context "handle_connection_error" do

    it "raise exception when Faraday ressource is not found" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_raise(Faraday::Error::ResourceNotFound, "not found")
      expect{ client.get_safebox_info({safebox_guid: 123}) }.to raise_error SendSecure::SendSecureException, "not found"
    end

    it "raise exception on error with Faraday" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_raise(Faraday::Error, "Problems with Faraday")
      expect{ client.get_safebox_info({safebox_guid: 123}) }.to raise_error SendSecure::SendSecureException, "Problems with Faraday"
    end

  end

end
