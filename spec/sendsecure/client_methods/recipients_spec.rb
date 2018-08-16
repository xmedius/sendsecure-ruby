require 'spec_helper'

describe SendSecure::ClientMethods::Recipients do
  let(:client) { SendSecure::Client.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "search_recipient" do

    it "return list of recipients on success" do
      list_of_recipients = [{ "id"=>7514,
                                "type"=>"favorite",
                                "first_name"=>"John",
                                "last_name"=>"Smith",
                                "email"=>"john.smith@example.com",
                                "company_name"=>"Acme"
                              },
                              { "id"=>150848,
                                "type"=>"user",
                                "first_name"=>"johnny",
                                "last_name"=>"smith",
                                "email"=>"john124@example.com",
                                "company_name"=>"acme"
                              }]
      response_body = { "results"=> list_of_recipients }
      expect(client.json_client).to receive(:search_recipient).with("John").and_return(response_body)
      result = client.search_recipient("John")
      expect(result["results"]).to eq(list_of_recipients)
    end

    it "raise exception when searching for nil" do
      expect{ client.search_recipient(nil) }.to raise_error SendSecure::SendSecureException, "Search term cannot be null"
    end

  end

end