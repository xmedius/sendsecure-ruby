require 'spec_helper'
require 'date'

describe SendSecure::SafeBox do
  let(:new_safebox) { SendSecure::SafeBox.new( {  "user_email": "user@acme.com",
                                                  "guid": "1c820789a50747df8746aa5d71922a3f",
                                                  "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                                                  "message": "lorem ipsum...",
                                                  "subject": "test subject"
                                                }) }

  let(:safebox) { SendSecure::SafeBox.new( {  "user_email": "user@acme.com",
                                              "guid": "1c820789a50747df8746aa5d71922a3f",
                                              "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                                              "upload_url": "upload_url",
                                              "participants": [{
                                                "id": "7a3c51e00a004917a8f5db807180fcc5",
                                                "first_name": "John",
                                                "last_name": "Smith",
                                                "email": "john.smith@example.com",
                                                "type": "guest",
                                                "role": "guest",
                                                "guest_options": {
                                                  "company_name": "Acme",
                                                  "locked": false,
                                                  "bounced_email": false,
                                                  "failed_login_attempts": 0,
                                                  "verified": false,
                                                  "contact_methods": [{ "id": 1,
                                                                        "destination": "+15145550000",
                                                                        "destination_type": "office_phone",
                                                                        "verified": false,
                                                                        "created_at": "2017-04-28T17:14:55.304Z",
                                                                        "updated_at": "2017-04-28T17:14:55.304Z" }]
                                                }},
                                              { "id": "1",
                                                "first_name": "Jane",
                                                "last_name": "Doe",
                                                "email": "jane.doe@example.com",
                                                "type": "user",
                                                "role": "owner",
                                              }],
                                              "attachments": [{
                                                "guid": "123",
                                                "file_path": Dir.pwd + "/spec/data/simple.pdf",
                                                "content_type": "application/pdf"
                                              }],
                                              "message": "lorem ipsum...",
                                              "subject": "test subject",
                                              "notification_language": "fr",
                                              "security_profile_id": 11,
                                              "security_options": {
                                                "security_code_length": 4,
                                                "code_time_limit": 5,
                                                "allowed_login_attempts": 3,
                                                "allow_remember_me": true,
                                                "allow_sms": true,
                                                "allow_voice": true,
                                                "allow_email": false,
                                                "reply_enabled": true,
                                                "group_replies": false,
                                                "expiration_value": 5,
                                                "expiration_unit": "days",
                                                "retention_period_type": "do_not_discard",
                                                "retention_period_value": nil,
                                                "retention_period_unit": "hours",
                                                "encrypt_message": true,
                                                "double_encryption": true,
                                                "two_factor_required": true,
                                                "auto_extend_value": 3,
                                                "auto_extend_unit": "days",
                                                "delete_content_on": nil,
                                                "allow_manual_delete": true,
                                                "allow_manual_close": false,
                                                "encrypt_attachments": false
                                              },
                                              "user_id": 1,
                                              "enterprise_id": 1,
                                              "status": "in_progress",
                                              "security_profile_name": "All Contact Method Allowed!",
                                              "unread_count": 0,
                                              "double_encryption_status": "disabled",
                                              "audit_record_pdf": nil,
                                              "secure_link": nil,
                                              "secure_link_title": nil,
                                              "email_notification_enabled": true,
                                              "preview_url": "https://sendsecure.integration.xmedius.com/s/845459484b674055bec4ddf2ba5ab60e/preview",
                                              "encryption_key": nil,
                                              "created_at": "2017-05-24T14:45:35.062Z",
                                              "updated_at": "2017-05-24T14:45:35.589Z",
                                              "assigned_at": "2017-05-24T14:45:35.040Z",
                                              "latest_activity": "2017-05-24T14:45:35.544Z",
                                              "expiration": "2017-05-31T14:45:35.038Z",
                                              "closed_at": nil,
                                              "content_deleted_at": nil,
                                              "messages": [{
                                                "note": "Lorem Ipsum...",
                                                "note_size": 123,
                                                "read": true,
                                                "author_id": "1",
                                                "author_type": "guest",
                                                "created_at": "2017-04-05T14:49:35.198Z",
                                                "documents": [{
                                                  "id": "5a3df276aaa24e43af5aca9b2204a535",
                                                  "name": "Axient-soapui-project.xml",
                                                  "sha": "724ae04430315c60ca17f4dbee775a37f5b18c91fde6eef24f77a605aee99c9c",
                                                  "size": 12345,
                                                  "url": "https://sendsecure.integration.xmedius.com/api/v2/safeboxes/b4d898ada15f42f293e31905c514607f/documents/5a3df276aaa24e43af5aca9b2204a535/url"
                                                }]
                                              }],
                                              "download_activity": {
                                                "guests": [{
                                                  "id": "42220c777c30486e80cd3bbfa7f8e82f",
                                                  "documents": [{
                                                    "id": "5a3df276aaa24e43af5aca9b2204a535",
                                                    "downloaded_bytes": 0,
                                                    "download_date": nil
                                                  }]
                                                }],
                                                "owner": {
                                                  "id": 1,
                                                  "documents": []
                                                }
                                              },
                                              "event_history": [{
                                                "type": "safebox_created_owner",
                                                "date": "2017-03-30T18:09:05.966Z",
                                                "metadata": {
                                                  "emails": [
                                                    "john44@example.com"
                                                  ],
                                                  "attachment_count": 0
                                                },
                                                "message": "SafeBox créée par laurence4815@gmail.com avec 0 pièce(s) jointe(s) depuis 192.168.0.1 pour john44@example.com"
                                              }]
                                            }) }

  context "create safebox with" do

    it "all the basic attributes" do
      expect(safebox.user_email).to eq("user@acme.com")
      expect(safebox.guid).to eq("1c820789a50747df8746aa5d71922a3f")
      expect(safebox.public_encryption_key).to eq("AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz")
      expect(safebox.upload_url).to eq("upload_url")
      expect(safebox.message).to eq("lorem ipsum...")
      expect(safebox.subject).to eq("test subject")
      expect(safebox.notification_language).to eq("fr")
      expect(safebox.security_profile_id).to eq(11)
      expect(safebox.user_id).to eq(1)
      expect(safebox.enterprise_id).to eq(1)
      expect(safebox.status).to eq("in_progress")
      expect(safebox.security_profile_name).to eq("All Contact Method Allowed!")
      expect(safebox.unread_count).to eq(0)
      expect(safebox.double_encryption_status).to eq("disabled")
      expect(safebox.audit_record_pdf).to be_nil
      expect(safebox.secure_link).to be_nil
      expect(safebox.secure_link_title).to be_nil
      expect(safebox.email_notification_enabled).to eq(true)
      expect(safebox.preview_url).to eq("https://sendsecure.integration.xmedius.com/s/845459484b674055bec4ddf2ba5ab60e/preview")
      expect(safebox.encryption_key).to be_nil
      expect(safebox.created_at).to eq("2017-05-24T14:45:35.062Z")
      expect(safebox.updated_at).to eq("2017-05-24T14:45:35.589Z")
      expect(safebox.assigned_at).to eq("2017-05-24T14:45:35.040Z")
      expect(safebox.latest_activity).to eq("2017-05-24T14:45:35.544Z")
      expect(safebox.expiration).to eq("2017-05-31T14:45:35.038Z")
      expect(safebox.closed_at).to be_nil
      expect(safebox.content_deleted_at).to be_nil
    end

    it "attachments attributes" do
      expect(safebox.attachments.size).to eq(1)
      attachment = safebox.attachments[0]
      expect(attachment.is_a?(SendSecure::Attachment)).to eq(true)
      expect(attachment.guid).to eq("123")
      expect(attachment.file_path).to eq(Dir.pwd + "/spec/data/simple.pdf")
      expect(attachment.content_type).to eq("application/pdf")
    end

    it "security options attributes" do
      security_options = safebox.security_options
      expect(security_options.is_a?(SendSecure::SecurityOptions)).to eq(true)
      expect(security_options.security_code_length).to eq(4)
      expect(security_options.allowed_login_attempts).to eq(3)
      expect(security_options.expiration_value).to eq(5)
      expect(security_options.expiration_unit).to eq("days")
      expect(security_options.allow_remember_me).to eq(true)
      expect(security_options.allow_sms).to eq(true)
      expect(security_options.allow_voice).to eq(true)
      expect(security_options.allow_email).to eq(false)
      expect(security_options.reply_enabled).to eq(true)
      expect(security_options.group_replies).to eq(false)
      expect(security_options.code_time_limit).to eq(5)
      expect(security_options.encrypt_message).to eq(true)
      expect(security_options.two_factor_required).to eq(true)
      expect(security_options.auto_extend_value).to eq(3)
      expect(security_options.auto_extend_unit).to eq("days")
      expect(security_options.retention_period_type).to eq("do_not_discard")
      expect(security_options.retention_period_value).to be_nil
      expect(security_options.retention_period_unit).to eq("hours")
      expect(security_options.allow_manual_delete).to eq(true)
      expect(security_options.allow_manual_close).to eq(false)
      expect(security_options.double_encryption).to eq(true)
      expect(security_options.encrypt_attachments).to eq(false)
    end

    context "date and time attributes" do

      it "raise exception on failure" do
        date_time = DateTime.new(2018,5,3,4,5,6)
        expect { safebox.expiration_values = date_time }.to raise_error SendSecure::SendSecureException, "Cannot change the expiration of a committed safebox, please see the method add_time to extend the lifetime of the safebox"
      end

      it "set date and time attributes" do
        date_time = DateTime.new(2018,5,3,4,5,6)
        new_safebox.expiration_values = date_time
        expect(new_safebox.security_options.expiration_date).to eq(date_time.strftime("%Y-%m-%d"))
        expect(new_safebox.security_options.expiration_time).to eq(date_time.strftime("%H:%M:%S"))
        expect(new_safebox.security_options.expiration_time_zone).to eq(date_time.zone)
      end
    end

    context "participants" do

      it "basic attributes" do
        expect(safebox.participants.size).to eq(2)
        participant = safebox.participants[0]
        expect(participant.is_a?(SendSecure::Participant)).to eq(true)
        expect(participant.id).to eq("7a3c51e00a004917a8f5db807180fcc5")
        expect(participant.first_name).to eq("John")
        expect(participant.last_name).to eq("Smith")
        expect(participant.email).to eq("john.smith@example.com")
        expect(participant.type).to eq("guest")
        expect(participant.role).to eq("guest")

        participant = safebox.participants[1]
        expect(participant.is_a?(SendSecure::Participant)).to eq(true)
        expect(participant.id).to eq("1")
        expect(participant.first_name).to eq("Jane")
        expect(participant.last_name).to eq("Doe")
        expect(participant.email).to eq("jane.doe@example.com")
        expect(participant.type).to eq("user")
        expect(participant.role).to eq("owner")
        expect(participant.guest_options).to be_nil
      end

      context "guest options" do

        it "guest options basic attributes" do
          guest_options = safebox.participants[0].guest_options
          expect(guest_options.is_a?(SendSecure::GuestOptions)).to eq(true)
          expect(guest_options.company_name).to eq("Acme")
          expect(guest_options.locked).to eq(false)
          expect(guest_options.bounced_email).to eq(false)
          expect(guest_options.failed_login_attempts).to eq(0)
          expect(guest_options.verified).to eq(false)
          expect(guest_options.contact_methods.size).to eq(1)
        end

        it "contact methods attributes" do
          contact = safebox.participants[0].guest_options.contact_methods[0]
          expect(contact.is_a?(SendSecure::ContactMethod)).to eq(true)
          expect(contact.id).to eq(1)
          expect(contact.destination_type).to eq("office_phone")
          expect(contact.destination).to eq("+15145550000")
          expect(contact.verified).to eq(false)
          expect(contact.created_at).to eq("2017-04-28T17:14:55.304Z")
          expect(contact.updated_at).to eq("2017-04-28T17:14:55.304Z")
        end
      end
    end

    context "messages" do

      it "basic attributes" do
        expect(safebox.messages.size).to eq(1)
        message = safebox.messages[0]
        expect(message.is_a?(SendSecure::Message)).to eq(true)
        expect(message.note).to eq("Lorem Ipsum...")
        expect(message.note_size).to eq(123)
        expect(message.read).to eq(true)
        expect(message.author_id).to eq("1")
        expect(message.author_type).to eq("guest")
        expect(message.created_at).to eq("2017-04-05T14:49:35.198Z")
        expect(message.documents.size).to eq(1)
      end

      it "documents attributes" do
        document = safebox.messages[0].documents[0]
        expect(document.is_a?(SendSecure::MessageDocument)).to eq(true)
        expect(document.id).to eq("5a3df276aaa24e43af5aca9b2204a535")
        expect(document.name).to eq("Axient-soapui-project.xml")
        expect(document.sha).to eq("724ae04430315c60ca17f4dbee775a37f5b18c91fde6eef24f77a605aee99c9c")
        expect(document.size).to eq(12345)
        expect(document.url).to eq("https://sendsecure.integration.xmedius.com/api/v2/safeboxes/b4d898ada15f42f293e31905c514607f/documents/5a3df276aaa24e43af5aca9b2204a535/url")
      end
    end

    context "download activity" do

      it "basic attributes" do
        download_activity = safebox.download_activity
        expect(download_activity.is_a?(SendSecure::DownloadActivity)).to eq(true)
        expect(download_activity.owner.is_a?(SendSecure::DownloadActivityDetail)).to eq(true)
        expect(download_activity.guests.size).to eq(1)
        expect(download_activity.guests[0].is_a?(SendSecure::DownloadActivityDetail)).to eq(true)

      end

      it "guests/owner attrbiutes" do
        owner = safebox.download_activity.owner
        expect(owner.id).to eq(1)
        expect(owner.documents).to be_empty

        guest = safebox.download_activity.guests[0]
        expect(guest.id).to eq("42220c777c30486e80cd3bbfa7f8e82f")
        expect(guest.documents.size).to eq(1)
      end

      it "documents attributes" do
        document = safebox.download_activity.guests[0].documents[0]
        expect(document.is_a?(SendSecure::DownloadActivityDocument)).to eq(true)
        expect(document.id).to eq("5a3df276aaa24e43af5aca9b2204a535")
        expect(document.downloaded_bytes).to eq(0)
        expect(document.download_date).to be_nil
      end
    end

    it "event history attributes" do
      expect(safebox.event_history.size).to eq(1)
      event_history = safebox.event_history[0]
      expect(event_history.is_a?(SendSecure::EventHistory)).to eq(true)
      expect(event_history.type).to eq("safebox_created_owner")
      expect(event_history.date).to eq("2017-03-30T18:09:05.966Z")

      metadata = event_history.metadata
      expect(metadata[:emails].size).to eq(1)
      expect(metadata[:emails][0]).to eq("john44@example.com")
      expect(metadata[:attachment_count]).to eq(0)
      expect(event_history.message).to eq("SafeBox créée par laurence4815@gmail.com avec 0 pièce(s) jointe(s) depuis 192.168.0.1 pour john44@example.com")
    end
  end

  it "serialize safebox" do
    safebox_json = {  "safebox"=>{
                        "guid"=>"1c820789a50747df8746aa5d71922a3f",
                        "subject"=>"test subject",
                        "message"=>"lorem ipsum...",
                        "security_profile_id"=>11,
                        "public_encryption_key"=>"AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
                        "notification_language"=>"fr",
                        "user_email"=>"user@acme.com",
                        "email_notification_enabled"=>true,
                        "document_ids"=>["123"],
                        "recipients"=>[{
                          "first_name"=>"John",
                          "last_name"=>"Smith",
                          "email"=>"john.smith@example.com",
                          "company_name"=>"Acme",
                          "contact_methods"=>[{
                            "destination"=>"+15145550000",
                            "destination_type"=>"office_phone"
                          }]
                        },
                        {"first_name"=>"Jane",
                         "last_name"=>"Doe",
                         "email"=>"jane.doe@example.com",
                        }],
                        "reply_enabled"=>true,
                        "group_replies"=>false,
                        "retention_period_type"=>"do_not_discard",
                        "retention_period_value"=>nil,
                        "retention_period_unit"=>"hours",
                        "encrypt_message"=>true,
                        "double_encryption"=>true,
                        "expiration_value"=>5,
                        "expiration_unit"=>"days"
                      }
                    }
    expect(safebox.to_json(is_creation: true)).to eq(safebox_json)
  end

  context "update_attributes" do
    let!(:update_safebox_params) {{ "user_email": "user@acme.com",
                                    "guid": "1c820789a50747df8746aa5d71922a3f",
                                    "participants": [{
                                      "id": "7a3c51e00a004917a8f5db807180fcc5",
                                      "first_name": "test",
                                      "last_name": "user",
                                      "email": "john.smith@example.com",
                                      "guest_options": {
                                        "company_name": "Acme",
                                        "locked": true,
                                        "contact_methods": [{
                                          "id": 2,
                                          "destination": "+15145550001",
                                          "destination_type": "cell_phone",
                                          "verified": false,
                                          "created_at": "2017-05-28T17:14:55.304Z",
                                          "updated_at": "2017-05-28T17:14:55.304Z"
                                        }]
                                      }}],
                                    "created_at": "2017-05-24T14:45:35.062Z",
                                    "updated_at": "2017-05-24T14:45:35.589Z"
                                  }}

    it "unaffected attributes stay unchanged" do
      safebox.update_attributes(update_safebox_params)
      expect(safebox.user_email).to eq("user@acme.com")
      expect(safebox.guid).to eq("1c820789a50747df8746aa5d71922a3f")
      expect(safebox.created_at).to eq("2017-05-24T14:45:35.062Z")
      expect(safebox.updated_at).to eq("2017-05-24T14:45:35.589Z")
      expect(safebox.participants.size).to eq(2)
      participant = safebox.participants[0]
      expect(participant.email).to eq("john.smith@example.com")
      expect(participant.id).to eq("7a3c51e00a004917a8f5db807180fcc5")
      expect(participant.guest_options.company_name).to eq("Acme")
      expect(safebox.messages.size).to eq(1)
      expect(safebox.event_history.size).to eq(1)
    end

    it "removed objects are correctly deleted from the list" do
      safebox.update_attributes(update_safebox_params)
      contact = safebox.participants[0].guest_options.contact_methods
      expect(contact.size).to eq(1)
      expect(contact.map(&:id)).not_to include(1)
    end

    it "new objects are correctly added to the list" do
      safebox.update_attributes(update_safebox_params)
      contact = safebox.participants[0].guest_options.contact_methods[0]
      expect(contact.id).to eq(2)
      expect(contact.destination_type).to eq("cell_phone")
      expect(contact.destination).to eq("+15145550001")
      expect(contact.created_at).to eq("2017-05-28T17:14:55.304Z")
      expect(contact.updated_at).to eq("2017-05-28T17:14:55.304Z")
    end

    it "all changed attributes are correctly updated" do
      safebox.update_attributes(update_safebox_params)
      participant = safebox.participants[0]
      expect(participant.first_name).to eq("test")
      expect(participant.last_name).to eq("user")
      guest_options = participant.guest_options
      expect(guest_options.locked).to eq(true)
    end

  end

end
