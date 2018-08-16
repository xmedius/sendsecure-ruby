require 'spec_helper'

describe SendSecure::JsonMethods::Recipients do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }

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
      term = "John"
      sendsecure_connection do |stubs|
        stubs.get("api/v2/participants/autocomplete?term=#{term}") { |env| [ 200, {}, response_body ]}
      end
      expect(client).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.search_recipient(term)
      expect(result["results"]).to eq(list_of_recipients)
    end

  end

end