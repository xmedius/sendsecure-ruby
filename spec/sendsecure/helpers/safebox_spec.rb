require 'spec_helper'

describe SendSecure::SafeBox do
  let(:sb) { SendSecure::SafeBox.new( { "user_email": "user@acme.com", "guid": "1c820789a50747df8746aa5d71922a3f", "public_encryption_key": "AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz", "upload_url": "upload_url",
        "recipients": [ {"email": "user@test.com", "contact_methods": [{"destination_type": "office_phone","destination": "+15145550000"}, {"destination": "+15145550001"}]}],
        "attachments": [ {"guid": "123", "file_path": Dir.pwd + "/spec/data/simple.pdf", "content_type": "application/pdf"}], "message": "lorem ipsum...", subject: "test subject",
        "notification_language": "fr", "security_profile_id": 11, "reply_enabled": true, "group_replies": false, "expiration_value": 5, "expiration_unit": "days", "retention_period_type": "discard_at_expiration", "encrypt_message": false, "double_encryption": true
        }) }

  it "create safebox with all the attributes" do
    expect(sb.user_email).to eq("user@acme.com")
    expect(sb.guid).to eq("1c820789a50747df8746aa5d71922a3f")
    expect(sb.public_encryption_key).to eq("AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz")
    expect(sb.upload_url).to eq("upload_url")
    expect(sb.message).to eq("lorem ipsum...")
    expect(sb.subject).to eq("test subject")
    expect(sb.notification_language).to eq("fr")
    expect(sb.security_profile_id).to eq(11)
    expect(sb.reply_enabled).to eq(true)
    expect(sb.group_replies).to eq(false)
    expect(sb.expiration_value).to eq(5)
    expect(sb.expiration_unit).to eq("days")
    expect(sb.retention_period_type).to eq("discard_at_expiration")
    expect(sb.encrypt_message).to eq(false)
    expect(sb.double_encryption).to eq(true)

    expect(sb.recipients.size).to eq(1)
    recipient = sb.recipients[0]
    expect(recipient.is_a?(SendSecure::Recipient)).to eq(true)
    expect(recipient.email).to eq("user@test.com")

    expect(recipient.contact_methods.size).to eq(2)
    contact = recipient.contact_methods[0]
    expect(contact.is_a?(SendSecure::ContactMethod)).to eq(true)
    expect(contact.destination_type).to eq("office_phone")
    expect(contact.destination).to eq("+15145550000")
    contact = recipient.contact_methods[1]
    expect(contact.is_a?(SendSecure::ContactMethod)).to eq(true)
    expect(contact.destination_type).to eq(nil)
    expect(contact.destination).to eq("+15145550001")

    expect(sb.attachments.size).to eq(1)
    attachment = sb.attachments[0]
    expect(attachment.is_a?(SendSecure::Attachment)).to eq(true)
    expect(attachment.guid).to eq("123")
    expect(attachment.file_path).to eq(Dir.pwd + "/spec/data/simple.pdf")
    expect(attachment.content_type).to eq("application/pdf")
  end

  it "serialize safebox" do
    expect(sb.to_json).to eq({"safebox"=>{"user_email"=>"user@acme.com", "guid"=>"1c820789a50747df8746aa5d71922a3f", "public_encryption_key"=>"AyOmyAawJXKepb9LuJAOyiJXvkpEQcdSweS2-It3jaRntO9rRyCaciv7QBt5Dqoz",
      "upload_url"=>"upload_url", "recipients"=>[{"email"=>"user@test.com", "contact_methods"=>[{"destination_type"=>"office_phone", "destination"=>"+15145550000"}, {"destination"=>"+15145550001"}]}],
      "message"=>"lorem ipsum...", "subject"=>"test subject", "notification_language"=>"fr", "security_profile_id"=>11, "reply_enabled"=>true, "group_replies"=>false, "expiration_value"=>5,
      "expiration_unit"=>"days", "retention_period_type"=>"discard_at_expiration", "encrypt_message"=>false, "double_encryption"=>true,
      "document_ids"=>["123"]}}
    )
  end

end
