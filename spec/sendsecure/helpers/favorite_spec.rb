require 'spec_helper'

describe SendSecure::Favorite do
  let(:favorite) { SendSecure::Favorite.new({ "email": "john.smith@example.com",
                                              "id": 1,
                                              "first_name": "John",
                                              "last_name": "Smith",
                                              "company_name": "Acme",
                                              "order_number": 1,
                                              "created_at": "2017-04-12T15:41:39.767Z",
                                              "updated_at": "2017-04-12T15:41:47.144Z",
                                              "contact_methods": [
                                              {
                                                "id": 1,
                                                "destination": "+15145550000",
                                                "destination_type": "office_phone",
                                                "created_at": "2017-04-28T17:14:55.304Z",
                                                "updated_at": "2017-04-28T17:14:55.304Z"
                                              },
                                              {
                                                "id": 2,
                                                "destination": "+15145550001",
                                                "destination_type": "cell_phone",
                                                "created_at": "2017-04-28T18:14:55.304Z",
                                                "updated_at": "2017-04-28T18:14:55.304Z"
                                              }]
                                            }) }

  context "create favorite with" do

    it "all the basic attributes" do
      expect(favorite.email).to eq("john.smith@example.com")
      expect(favorite.id).to eq(1)
      expect(favorite.first_name).to eq("John")
      expect(favorite.last_name).to eq("Smith")
      expect(favorite.company_name).to eq("Acme")
      expect(favorite.order_number).to eq(1)
      expect(favorite.created_at).to eq("2017-04-12T15:41:39.767Z")
      expect(favorite.updated_at).to eq("2017-04-12T15:41:47.144Z")
    end

    it "contact methods attributes" do
      expect(favorite.contact_methods.size).to eq(2)
      contact = favorite.contact_methods[0]
      expect(contact.is_a?(SendSecure::ContactMethod)).to eq(true)
      expect(contact.id).to eq(1)
      expect(contact.destination_type).to eq("office_phone")
      expect(contact.destination).to eq("+15145550000")
      expect(contact.created_at).to eq("2017-04-28T17:14:55.304Z")
      expect(contact.updated_at).to eq("2017-04-28T17:14:55.304Z")

      contact = favorite.contact_methods[1]
      expect(contact.is_a?(SendSecure::ContactMethod)).to eq(true)
      expect(contact.id).to eq(2)
      expect(contact.destination_type).to eq("cell_phone")
      expect(contact.destination).to eq("+15145550001")
      expect(contact.created_at).to eq("2017-04-28T18:14:55.304Z")
      expect(contact.updated_at).to eq("2017-04-28T18:14:55.304Z")
    end

  end

  context "serialize favorite" do

    it "on creation" do
      favorite_json = { "favorite"=>{
                          "email"=>"john.smith@example.com",
                          "first_name"=>"John",
                          "last_name"=>"Smith",
                          "company_name"=>"Acme",
                          "contact_methods"=>[
                          {
                            "destination_type"=>"office_phone",
                            "destination"=>"+15145550000"
                          },
                          {
                            "destination_type"=>"cell_phone",
                            "destination"=>"+15145550001"
                          }]
                        }
                      }
      expect(favorite.to_json(is_creation: true)).to eq(favorite_json)
    end

    it "on edit" do
      favorite_json = { "favorite"=>{
                          "email"=>"john.smith@example.com",
                          "first_name"=>"John",
                          "last_name"=>"Smith",
                          "company_name"=>"Acme",
                          "order_number"=>1,
                          "contact_methods"=>[
                          {
                            "id"=>1,
                            "destination_type"=>"office_phone",
                            "destination"=>"+15145550000"
                          },
                          {
                            "id"=>2,
                            "destination_type"=>"cell_phone",
                            "destination"=>"+15145550001"
                          }]
                        }
                      }
      expect(favorite.to_json(is_creation: false)).to eq(favorite_json)
    end

    it "on delete contacts" do
      favorite_json = { "favorite"=>{
                          "email"=>"john.smith@example.com",
                          "first_name"=>"John",
                          "last_name"=>"Smith",
                          "company_name"=>"Acme",
                          "order_number"=>1,
                          "contact_methods"=>[
                          {
                            "id"=>1,
                            "destination_type"=>"office_phone",
                            "destination"=>"+15145550000",
                            "_destroy"=>true
                          },
                          {
                            "id"=>2,
                            "destination_type"=>"cell_phone",
                            "destination"=>"+15145550001"
                          }]
                        }
                      }
      favorite.prepare_to_destroy_contact([1])
      expect(favorite.to_json(destroy_contacts: true)).to eq(favorite_json)
    end

  end

end