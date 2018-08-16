require 'spec_helper'

describe SendSecure::ClientMethods::ConsentGroup do
  let(:client) { SendSecure::Client.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", user_id: 123, enterprise_account: "acme") }

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
                           "consent_messages"=> [{
                              "locale"=> "en",
                              "value"=> "Lorem ipsum",
                              "created_at"=> "2016-08-29T14:52:26.085Z",
                              "updated_at"=> "2016-08-29T14:52:26.085Z"
                            }]}}
      expect(client.json_client).to receive(:get_consent_group_messages).with(1).and_return(response_body)
      result = client.get_consent_group_messages(1)
      expect(result.id).to eq(1);
      expect(result.name).to eq("Default");
      expect(result.consent_messages.length).to eq(1);
    end

  end
end
