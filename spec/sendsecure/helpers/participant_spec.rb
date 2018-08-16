require 'spec_helper'

describe SendSecure::Participant do
  let(:participant) { SendSecure::Participant.new({ "id": "7a3c51e00a004917a8f5db807180fcc5",
                                                    "first_name": "John",
                                                    "last_name": "Smith",
                                                    "email": "john.smith@example.com",
                                                    "type": "guest",
                                                    "role": "guest",
                                                    "message_read_count": 0,
                                                    "message_total_count": 1,
                                                    "guest_options": {
                                                      "company_name": "Acme",
                                                      "locked": false,
                                                      "bounced_email": false,
                                                      "failed_login_attempts": 0,
                                                      "verified": false,
                                                      "contact_methods": [
                                                      {
                                                        "id": 1,
                                                        "destination": "+15145550000",
                                                        "destination_type": "office_phone",
                                                        "verified": false,
                                                        "created_at": "2017-04-28T17:14:55.304Z",
                                                        "updated_at": "2017-04-28T17:14:55.304Z"
                                                      },
                                                      { "id": 2,
                                                        "destination": "+15145550001",
                                                        "destination_type": "cell_phone",
                                                        "verified": true,
                                                        "created_at": "2017-04-28T18:14:55.304Z",
                                                        "updated_at": "2017-04-28T18:14:55.304Z"
                                                      }]
                                                    }
                                                  }) }

  context "create participant with" do

    it "all the basic attributes" do
      expect(participant.id).to eq("7a3c51e00a004917a8f5db807180fcc5")
      expect(participant.first_name).to eq("John")
      expect(participant.last_name).to eq("Smith")
      expect(participant.email).to eq("john.smith@example.com")
      expect(participant.type).to eq("guest")
      expect(participant.role).to eq("guest")
      expect(participant.message_read_count).to eq(0)
      expect(participant.message_total_count).to eq(1)
    end

    context "guest options" do

      it "basic attributes" do
        guest_options = participant.guest_options
        expect(guest_options.is_a?(SendSecure::GuestOptions)).to eq(true)
        expect(guest_options.company_name).to eq("Acme")
        expect(guest_options.locked).to eq(false)
        expect(guest_options.bounced_email).to eq(false)
        expect(guest_options.failed_login_attempts).to eq(0)
        expect(guest_options.verified).to eq(false)
      end

      it "contact methods attributes" do
        guest_options = participant.guest_options
        expect(guest_options.contact_methods.size).to eq(2)
        contact = guest_options.contact_methods[0]
        expect(contact.is_a?(SendSecure::ContactMethod)).to eq(true)
        expect(contact.id).to eq(1)
        expect(contact.destination_type).to eq("office_phone")
        expect(contact.destination).to eq("+15145550000")
        expect(contact.verified).to eq(false)
        expect(contact.created_at).to eq("2017-04-28T17:14:55.304Z")
        expect(contact.updated_at).to eq("2017-04-28T17:14:55.304Z")

        contact = guest_options.contact_methods[1]
        expect(contact.is_a?(SendSecure::ContactMethod)).to eq(true)
        expect(contact.id).to eq(2)
        expect(contact.destination_type).to eq("cell_phone")
        expect(contact.destination).to eq("+15145550001")
        expect(contact.verified).to eq(true)
        expect(contact.created_at).to eq("2017-04-28T18:14:55.304Z")
        expect(contact.updated_at).to eq("2017-04-28T18:14:55.304Z")
      end
    end
  end

  context "serialize participant" do

    it "on creation" do
      participant_json = {  "participant"=>{
                              "first_name"=>"John",
                              "last_name"=>"Smith",
                              "email"=>"john.smith@example.com",
                              "company_name"=>"Acme",
                              "contact_methods"=>[
                              {
                                "destination"=>"+15145550000",
                                "destination_type"=>"office_phone"
                              },
                              {
                                "destination"=>"+15145550001",
                                "destination_type"=>"cell_phone"
                              }]
                            }
                          }
      expect(participant.to_json(is_creation: true)).to eq(participant_json)
    end

    it "on edit" do
      participant_json = {  "participant"=>{
                              "first_name"=>"John",
                              "last_name"=>"Smith",
                              "email"=>"john.smith@example.com",
                              "company_name"=>"Acme",
                              "locked"=>false,
                              "contact_methods"=>[
                              {
                                "id"=>1,
                                "destination"=>"+15145550000",
                                "destination_type"=>"office_phone"
                              },
                              {
                                "id"=>2,
                                "destination"=>"+15145550001",
                                "destination_type"=>"cell_phone"
                              }]
                            }
                          }
      expect(participant.to_json(is_creation: false)).to eq(participant_json)
    end

    it "on delete contacts" do
      participant_json = {  "participant"=>{
                              "first_name"=>"John",
                              "last_name"=>"Smith",
                              "email"=>"john.smith@example.com",
                              "company_name"=>"Acme",
                              "locked"=>false,
                              "contact_methods"=>[
                              {
                                "id"=>1,
                                "destination"=>"+15145550000",
                                "destination_type"=>"office_phone",
                                "_destroy"=>true
                              },
                              {
                                "id"=>2,
                                "destination"=>"+15145550001",
                                "destination_type"=>"cell_phone"
                              }]
                            }
                          }
      participant.prepare_to_destroy_contact([1])
      expect(participant.to_json(destroy_contacts: true)).to eq(participant_json)
    end

  end

end