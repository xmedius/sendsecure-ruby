require 'spec_helper'

describe SendSecure::ClientMethods::UserMethods do
  let(:client) { SendSecure::Client.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", user_id: 123, enterprise_account: "acme") }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "user_settings" do

    it "return user_setting" do
      response_body = { "created_at" => "2016-03-15T19:58:11.588Z",
                        "updated_at" => "2016-09-28T18:32:16.643Z",
                        "mask_note" => false,
                        "open_first_transaction" => true,
                        "mark_as_read" => true,
                        "mark_as_read_delay" => 2,
                        "remember_key" => true,
                        "default_filter" => "unread",
                        "recipient_language" => nil,
                        "secure_link" => {
                          "enabled" => true,
                          "url" => "https://sendsecure.integration.xmedius.com/r/612328d944b842c68418375ffdc87b3f",
                          "security_profile_id" => 13
                        }
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:user_setting).and_return(response_body)
      result = client.user_settings
      expect(result.is_a?(SendSecure::UserSetting)).to eq(true)
      expect(result.secure_link.is_a?(SendSecure::PersonnalSecureLink)).to eq(true)
      expect(result.default_filter).to eq("unread")
    end
  end

  context "favorites" do

    it "return a list of favorites" do
      response_body = { "favorites" => [
                          { "email" => "john.smith@example.com",
                            "id" => 456,
                            "first_name" => "",
                            "last_name" => "Smith",
                            "company_name" => "Acme",
                            "order_number" => 10,
                            "created_at" => "2016-04-19T16:26:18.277Z",
                            "updated_at" => "2016-09-07T19:33:51.192Z",
                            "contact_methods"=>[
                              { "id" => 1,
                                "destination" => "+15145550000",
                                "destination_type" => "office_phone",
                                "created_at" => "2017-04-28T17:14:55.304Z",
                                "updated_at" => "2017-04-28T17:14:55.304Z" }
                            ] },
                          { "email" => "jane.doe@example.com",
                            "id" => 789,
                            "first_name" => "Jane",
                            "last_name" => "",
                            "company_name" => "Acme",
                            "order_number" => 20,
                            "created_at" => "2016-05-19T16:26:18.277Z",
                            "updated_at" => "2016-10-07T19:33:51.192Z",
                            "contact_methods" => [] }
                        ]
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:favorites).and_return(response_body)
      result = client.favorites
      expect(result.size).to eq(2)
      expect(result[0].is_a?(SendSecure::Favorite)).to eq(true)
    end
  end

  context "create_favorite" do

    it "return the updated favorite" do
      favorite = SendSecure::Favorite.new({ "email": "john.smith@example.com",
                                            "first_name": "",
                                            "last_name": "Smith",
                                            "company_name": "Acme",
                                            "contact_methods": [
                                              { "destination": "+15145550000",
                                                "destination_type": "office_phone" }
                                            ]
                                          })

      response_body = { "email" => "john.smith@example.com",
                        "id" => 456,
                        "first_name" => "",
                        "last_name" => "Smith",
                        "company_name" => "Acme",
                        "order_number" => 10,
                        "created_at" => "2016-04-19T16:26:18.277Z",
                        "updated_at" => "2016-09-07T19:33:51.192Z",
                        "contact_methods" => [
                          { "id" => 1,
                            "destination" => "+15145550000",
                            "destination_type" => "office_phone",
                            "created_at" => "2017-04-28T17:14:55.304Z",
                            "updated_at" => "2017-04-28T17:14:55.304Z"
                          }
                        ]
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:create_favorite).and_return(response_body)
      result = client.create_favorite(favorite)
      expect(result.is_a?(SendSecure::Favorite)).to eq(true)
      expect(result.email).to eq("john.smith@example.com")
      expect(result.id).to eq(456)
      expect(result).to eq(favorite)
    end

    it "raise error if favorite email is missing" do
      favorite = SendSecure::Favorite.new({ "first_name": "",
                                            "last_name": "Smith",
                                            "company_name": "Acme",
                                            "contact_methods": [
                                              { "destination": "+15145550000",
                                                "destination_type": "office_phone" }
                                            ]
                                          })

      expect{ client.create_favorite(favorite) }.to raise_error SendSecure::SendSecureException, "Favorite email cannot be null"
    end

  end

  context "edit_favorite" do

    it "return the updated favorite" do
      favorite = SendSecure::Favorite.new({ "email": "john.smith@example.com",
                                            "id": 456,
                                            "last_name": "Smith",
                                            "company_name": "Acme",
                                            "order_number": 10,
                                            "contact_methods": [
                                              { "id": 1,
                                                "destination": "+15145550000",
                                                "destination_type": "office_phone" }
                                            ]
                                          })

      response_body = { "email" => "john.smith@example.com",
                        "id" => 456,
                        "first_name" => "",
                        "last_name" => "Smith",
                        "company_name" => "Acme",
                        "order_number" => 10,
                        "created_at" => "2016-04-19T16:26:18.277Z",
                        "updated_at" => "2016-09-07T19:33:51.192Z",
                        "contact_methods" => [
                          { "id" => 1,
                            "destination" => "+15145550000",
                            "destination_type" => "office_phone",
                            "created_at" => "2017-04-28T17:14:55.304Z",
                            "updated_at" => "2017-04-28T17:14:55.304Z" }
                        ]
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:edit_favorite).and_return(response_body)
      result = client.edit_favorite(favorite)
      expect(result.is_a?(SendSecure::Favorite)).to eq(true)
      expect(result.id).to eq(456)
      expect(result.created_at).to eq("2016-04-19T16:26:18.277Z")
      expect(result).to eq(favorite)
    end

    it "raise error if favorite id is missing" do
      favorite = SendSecure::Favorite.new({ "first_name": "",
                                            "last_name": "Smith",
                                            "company_name": "Acme",
                                            "contact_methods": [
                                              { "destination": "+15145550000",
                                                "destination_type": "office_phone" }
                                            ]
                                          })

      expect{ client.edit_favorite(favorite) }.to raise_error SendSecure::SendSecureException, "Favorite id cannot be null"
    end

  end

  context "delete_favorite_contact_methods" do

    it "return the updated favorite" do
      favorite = SendSecure::Favorite.new({ "email": "john.smith@example.com",
                                            "id": 456,
                                            "last_name": "Smith",
                                            "company_name": "Acme",
                                            "order_number": 10,
                                            "contact_methods": [
                                              { "id": 1,
                                                "destination": "+15145550000",
                                                "destination_type": "office_phone" }
                                            ]
                                          })

      response_body = { "email" => "john.smith@example.com",
                        "id" => 456,
                        "first_name" => "",
                        "last_name" => "Smith",
                        "company_name" => "Acme",
                        "order_number" => 10,
                        "created_at" => "2016-04-19T16:26:18.277Z",
                        "updated_at" => "2016-09-07T19:33:51.192Z",
                        "contact_methods" => []
                      }

      allow_any_instance_of(SendSecure::JsonClient).to receive(:edit_favorite).and_return(response_body)
      result = client.delete_favorite_contact_methods(favorite, [1])
      expect(result.is_a?(SendSecure::Favorite)).to eq(true)
      expect(result.id).to eq(456)
      expect(result.contact_methods).to be_empty
    end

    it "raise error if favorite id is missing" do
      favorite = SendSecure::Favorite.new({ "first_name": "",
                                            "last_name": "Smith",
                                            "company_name": "Acme",
                                            "contact_methods": [
                                              { "destination": "+15145550000",
                                                "destination_type": "office_phone" }
                                            ]
                                          })

      expect{ client.delete_favorite_contact_methods(favorite, [1]) }.to raise_error SendSecure::SendSecureException, "Favorite id cannot be null"
    end

  end

  context "delete_favorite" do

    it "return nothing on success" do
      allow_any_instance_of(SendSecure::JsonClient).to receive(:delete_favorite).and_return({})
      result = client.delete_favorite(123)
      expect(result).to be_empty
    end

  end

end
