require 'spec_helper'

describe SendSecure::JsonMethods::CreateSafeboxes do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "initialize_safebox" do

    it "return new safebox on success" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/safeboxes/new.json") { |env| [ 200, {}, ({ guid: "guid", public_encryption_key: "key", upload_url: "url"}).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      safebox = client.initialize_safebox("user@acme.com")
      expect(safebox.has_key?("guid")).to be true
      expect(safebox.has_key?("public_encryption_key")).to be true
      expect(safebox.has_key?("upload_url")).to be true
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/safeboxes/new.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.initialize_safebox("invalid_user@acme.com") }.to raise_error SendSecure::SendSecureException, "Access denied"
    end
  end

  context "commit_safebox" do
    let(:safebox_params) {{ "safebox":
                              { "guid": "1c820789a50747df8746aa5d71922a3f",
                                "recipients": [
                                  { "email": "recipient@test.xmedius.com",
                                    "contact_methods": [
                                      { "destination_type": "cell_phone",
                                        "destination": "+15145550000" }
                                    ]
                                  }
                                ],
                                "message": "lorem ipsum...",
                                "security_profile_id": 10,
                                "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                                "notification_language": "en"
                              }
                          }}

    it "return safebox info on success" do
      response_body = { "guid" => "1c820789a50747df8746aa5d71922a3f",
                        "user_id" => 3,
                        "enterprise_id" => 1 }
      sendsecure_connection do |stubs|
        stubs.post("/api/v2/safeboxes.json", safebox_params) { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.commit_safebox(safebox_params)
      expect(result.has_key?("guid")).to be true
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.post("/api/v2/safeboxes.json", safebox_params) { |env| [ 400, {}, {"error"=>"Some entered values are incorrect.", "attributes"=>{"language"=>["cannot be blank"]}} ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.commit_safebox(safebox_params) }.to raise_error SendSecure::SendSecureException, "Some entered values are incorrect. {\"language\"=>[\"cannot be blank\"]}"
    end

  end

  context "upload_file" do

    it "return document guid on success" do
      stubs = Faraday.new do |builder|
        builder.request :multipart
        builder.response :json, content_type: /\bjson$/

        builder.adapter :test do |stubs|
          stubs.post("/") { |env| [ 200, {}, { "temporary_document"=>{"document_guid"=>"5d4d6a8158b04915a532622983eb4493"}} ]}
        end
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:fileserver_connection).and_return(stubs)
      response = client.upload_file("http://upload_url/", Dir.pwd + "/spec/data/simple.pdf", "application/pdf")
      expect(response["temporary_document"]["document_guid"]).to eq("5d4d6a8158b04915a532622983eb4493")
    end

  end

end