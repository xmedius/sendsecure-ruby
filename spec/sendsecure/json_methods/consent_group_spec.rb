require 'spec_helper'

describe SendSecure::JsonMethods::ConsentGroup do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", user_id: 123, enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "get_consent_group_messages" do

      it "return the list of all the localized messages on success" do
        response_body = { "consent_message_group"=> {
                            "id"=> 1,
                            "name"=> "Default",
                            "created_at"=> "2016-08-29T14:52:26.085Z",
                            "updated_at"=> "2016-08-29T14:52:26.085Z",
                            "consent_messages"=> [
                              {
                                "locale"=> "en",
                                "value"=> "Lorem ipsum",
                                "created_at"=> "2016-08-29T14:52:26.085Z",
                                "updated_at"=> "2016-08-29T14:52:26.085Z"
                              }
                            ]
                          }
                        }
        sendsecure_connection do |stubs|
          stubs.get("api/v2/enterprises/acme/consent_message_groups/1") { |env| [ 200, {}, response_body ]}
        end
        expect(client).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        result = client.get_consent_group_messages(1)
        expect(result["consent_message_group"]["id"]).to eq(1);
        expect(result["consent_message_group"]["name"]).to eq("Default");
        expect(result["consent_message_group"]["consent_messages"].length).to eq(1);
      end

      it "raise exception on failure" do
        sendsecure_connection do |stubs|
          stubs.get("api/v2/enterprises/acme/consent_message_groups/42") { |env| [ 404, {}, ({ message: "The requested URL cannot be found." }).to_json ]}
        end
        expect(client).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        expect{ client.get_consent_group_messages(42) }.to raise_error SendSecure::SendSecureException, "The requested URL cannot be found."
      end

    end

end


