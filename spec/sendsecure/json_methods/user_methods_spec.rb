require 'spec_helper'

describe SendSecure::JsonMethods::UserMethods do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", user_id: 123, enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "user_setting" do

    it "return user_setting on success" do
      response_body = { "created_at" => "2016-03-15T19:58:11.588Z",
                        "updated_at" => "2016-09-28T18:32:16.643Z",
                        "default_filter" => "unread" }
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/users/123/settings.json") { |env| [ 200, {}, response_body ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      result = client.user_setting
      expect(result["default_filter"]).to eq("unread")
    end

    it "raise exception on failure" do
      sendsecure_connection do |stubs|
        stubs.get("api/v2/enterprises/acme/users/123/settings.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
      end
      allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
      expect{ client.user_setting }.to raise_error SendSecure::SendSecureException, "Access denied"
    end

  end

  context "favorites methods" do
    let(:favorite_id) { 456 }

    context "favorites" do

      it "return favorites on success" do
        response_body = { "favorites" => [
                            { "email" => "john.smith@example.com",
                              "id" => 456 },
                            { "email" => "jane.doe@example.com",
                              "id" => 789 }
                          ]
                        }
        sendsecure_connection do |stubs|
          stubs.get("api/v2/enterprises/acme/users/123/favorites.json") { |env| [ 200, {}, response_body ]}
        end
        allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        result = client.favorites
        expect(result["favorites"].size).to eq(2)
      end

      it "raise exception on failure" do
        sendsecure_connection do |stubs|
          stubs.get("api/v2/enterprises/acme/users/123/favorites.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
        end
        allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        expect{ client.favorites }.to raise_error SendSecure::SendSecureException, "Access denied"
      end

    end

    context "create_favorite" do
      let(:favorite_params) { { "favorite": {
                                  "first_name": "John",
                                  "last_name": "Smith",
                                  "email": "john.smith@example.com",
                                  "company_name": "Acme",
                                  "contact_methods":[
                                    { "destination": "+15145550000",
                                      "destination_type": "office_phone" },
                                    { "destination": "+15145550001",
                                      "destination_type": "cell_phone" }
                                  ]
                                }
                              } }

      it "return favorite info on success" do
        response_body = { "id" => favorite_id,
                          "created_at" => "2017-04-28T17:18:30.850Z",
                          "contact_methods" => [
                            { "id"=>1,
                              "created_at" => "2017-04-28T17:14:55.304Z" },
                            { "id"=>2,
                              "created_at" => "2017-04-28T18:14:55.304Z" }
                          ]
                        }
        sendsecure_connection do |stubs|
          stubs.post("api/v2/enterprises/acme/users/123/favorites.json", favorite_params) { |env| [ 200, {}, response_body ]}
        end
        allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        result = client.create_favorite(favorite_params)
        expect(result.has_key?("id")).to be true
        expect(result.has_key?("created_at")).to be true
        expect(result["contact_methods"].size).to eq(2)
        expect(result["contact_methods"][0].has_key?("id")).to be true
        expect(result["contact_methods"][0].has_key?("created_at")).to be true
      end

      it "raise exception on failure" do
        sendsecure_connection do |stubs|
          stubs.post("api/v2/enterprises/acme/users/123/favorites.json", favorite_params) { |env| [ 400, {}, {"error"=>"Some entered values are incorrect.", "attributes"=>{"email"=>["cannot be blank"]}} ]}
        end
        allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        expect{ client.create_favorite(favorite_params) }.to raise_error SendSecure::SendSecureException, "Some entered values are incorrect. {\"email\"=>[\"cannot be blank\"]}"
      end

    end

    context "edit_favorite" do
      let(:favorite_params) { { "favorite": {
                                  "first_name": "John",
                                  "last_name": "Smith",
                                  "email": "john.smith@example.com",
                                  "company_name": "Acme",
                                  "order_number": 10,
                                  "contact_methods":[
                                    { "id": 1,
                                      "destination": "+15145550000",
                                      "destination_type": "office_phone" },
                                    { "destination": "+15145550001",
                                      "destination_type": "cell_phone" }
                                  ]
                                }
                              } }

      it "return favorite info on success" do
        response_body = { "id" => favorite_id,
                          "created_at" => "2017-04-28T17:18:30.850Z",
                          "contact_methods" => [
                            { "id" => 1,
                              "created_at" => "2017-04-28T17:14:55.304Z" },
                            { "id" => 2,
                              "created_at" => "2017-04-28T18:14:55.304Z" }
                          ]
                        }
        sendsecure_connection do |stubs|
          stubs.patch("api/v2/enterprises/acme/users/123/favorites/#{favorite_id}.json", favorite_params) { |env| [ 200, {}, response_body ]}
        end
        allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        result = client.edit_favorite(favorite_id, favorite_params)
        expect(result.has_key?("id")).to be true
        expect(result.has_key?("created_at")).to be true
        expect(result["contact_methods"].size).to eq(2)
        expect(result["contact_methods"][0].has_key?("created_at")).to be true
      end

      it "raise exception on failure" do
        sendsecure_connection do |stubs|
          stubs.patch("api/v2/enterprises/acme/users/123/favorites/#{favorite_id}.json", favorite_params) { |env| [ 400, {}, {"error"=>"Some entered values are incorrect.", "attributes"=>{"email"=>["cannot be blank"]}} ]}
        end
        allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        expect{ client.edit_favorite(favorite_id, favorite_params) }.to raise_error SendSecure::SendSecureException, "Some entered values are incorrect. {\"email\"=>[\"cannot be blank\"]}"
      end

    end

    context "delete_favorite" do

      it "return nothing on success" do
        sendsecure_connection do |stubs|
          stubs.delete("api/v2/enterprises/acme/users/123/favorites/#{favorite_id}.json") { |env| [ 204, {}, ({}).to_json ]}
        end
        allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        result = client.delete_favorite(favorite_id)
        expect(result).to be_empty
      end

      it "raise exception on failure" do
        sendsecure_connection do |stubs|
          stubs.delete("api/v2/enterprises/acme/users/123/favorites/#{favorite_id}.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
        end
        allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
        expect{ client.delete_favorite(favorite_id) }.to raise_error SendSecure::SendSecureException, "Access denied"
      end

    end

  end

end