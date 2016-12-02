require 'spec_helper'

describe SendSecure::JsonClient do

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "new_safebox" do
    let(:client) { SendSecure::JsonClient.new("USER|489b3b1f-b411-428e-be5b-2abbace87689", "acme") }

    it "return new safebox on success" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      safebox = client.new_safebox("user@acme.com")
      expect(safebox.has_key?(:guid)).to be true
      expect(safebox.has_key?(:public_encryption_key)).to be true
      expect(safebox.has_key?(:upload_url)).to be true
    end

    it "raise exception on failure" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.new_safebox("invalid_user@acme.com") }.to raise_error SendSecure::SendSecureException, "user not found"
    end
  end

  private

  def sendsecure_connection
    Faraday.new do |builder|
      builder.response :json

      builder.adapter :test do |stubs|
        stubs.get("api/v2/safeboxes/new?user_email=user@acme.com&locale=en") { |env| [ 200, {}, { guid: "guid", public_encryption_key: "key", upload_url: "url"} ]}
        stubs.get("api/v2/safeboxes/new?user_email=invalid_user@acme.com&locale=en") { |env| [ 401, {}, ({ status: "401", message: "user not found"}).to_json ]}
      end
    end
  end
end
