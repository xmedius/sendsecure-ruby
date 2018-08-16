require 'spec_helper'

describe SendSecure::SecurityProfile do
  let(:profile) { SendSecure::SecurityProfile.new({ "id"=>10,
                                                    "name"=>"email-only",
                                                    "description"=>"",
                                                    "created_at"=>"2016-04-27T21:08:29.457Z",
                                                    "updated_at"=>"2016-07-27T19:03:05.883Z",
                                                    "allowed_login_attempts"=>{"value"=>3, "modifiable"=>false},
                                                    "allow_remember_me"=>{"value"=>false, "modifiable"=>false},
                                                    "allow_sms"=>{"value"=>false, "modifiable"=>false},
                                                    "allow_voice"=>{"value"=>false, "modifiable"=>false},
                                                    "allow_email"=>{"value"=>true, "modifiable"=>false},
                                                    "code_time_limit"=>{"value"=>5, "modifiable"=>false},
                                                    "code_length"=>{"value"=>4, "modifiable"=>false},
                                                    "auto_extend_value"=>{"value"=>3, "modifiable"=>false},
                                                    "auto_extend_unit"=>{"value"=>"days", "modifiable"=>false},
                                                    "two_factor_required"=>{"value"=>true, "modifiable"=>false},
                                                    "encrypt_attachments"=>{"value"=>true, "modifiable"=>false},
                                                    "encrypt_message"=>{"value"=>false, "modifiable"=>false},
                                                    "expiration_value"=>{"value"=>7, "modifiable"=>false},
                                                    "expiration_unit"=>{"value"=>"hours", "modifiable"=>false},
                                                    "reply_enabled"=>{"value"=>true, "modifiable"=>false},
                                                    "group_replies"=>{"value"=>false, "modifiable"=>false},
                                                    "double_encryption"=>{"value"=>true, "modifiable"=>false},
                                                    "retention_period_type"=>{"value"=>"discard_at_expiration", "modifiable"=>false},
                                                    "retention_period_value"=>{"value"=>nil, "modifiable"=>false},
                                                    "retention_period_unit"=>{"value"=>nil, "modifiable"=>false}
                                                  })
    }

  it "create security profile with all the attributes" do
    expect(profile.id).to eq(10)
    expect(profile.name).to eq("email-only")
    expect(profile.description).to eq("")
    expect(profile.created_at).to eq("2016-04-27T21:08:29.457Z")
    expect(profile.updated_at).to eq("2016-07-27T19:03:05.883Z")

    expect(profile.allowed_login_attempts.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.allowed_login_attempts.value).to eq(3)
    expect(profile.allowed_login_attempts.modifiable).to eq(false)

    expect(profile.allow_remember_me.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.allow_sms.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.allow_voice.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.allow_email.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.code_time_limit.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.code_length.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.auto_extend_value.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.auto_extend_unit.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.two_factor_required.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.encrypt_attachments.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.encrypt_message.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.expiration_value.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.expiration_unit.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.reply_enabled.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.group_replies.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.double_encryption.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.retention_period_type.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.retention_period_value.is_a?(SendSecure::Value)).to eq(true)
    expect(profile.retention_period_unit.is_a?(SendSecure::Value)).to eq(true)
  end

  it "serialize security profile" do
    expect(profile.to_json).to eq({ "securityprofile"=>{
                                      "id"=>10,
                                      "name"=>"email-only",
                                      "description"=>"",
                                      "allowed_login_attempts"=>{ "value"=>3, "modifiable"=>false },
                                      "allow_remember_me"=>{"value"=>false, "modifiable"=>false},
                                      "allow_sms"=>{"value"=>false, "modifiable"=>false},
                                      "allow_voice"=>{"value"=>false, "modifiable"=>false},
                                      "allow_email"=>{"value"=>true, "modifiable"=>false},
                                      "code_time_limit"=>{"value"=>5, "modifiable"=>false},
                                      "code_length"=>{"value"=>4, "modifiable"=>false},
                                      "auto_extend_value"=>{"value"=>3, "modifiable"=>false},
                                      "auto_extend_unit"=>{"value"=>"days", "modifiable"=>false},
                                      "two_factor_required"=>{"value"=>true, "modifiable"=>false},
                                      "encrypt_attachments"=>{"value"=>true, "modifiable"=>false},
                                      "encrypt_message"=>{"value"=>false, "modifiable"=>false},
                                      "expiration_value"=>{"value"=>7, "modifiable"=>false},
                                      "expiration_unit"=>{"value"=>"hours", "modifiable"=>false},
                                      "reply_enabled"=>{"value"=>true, "modifiable"=>false},
                                      "group_replies"=>{"value"=>false, "modifiable"=>false},
                                      "double_encryption"=>{"value"=>true, "modifiable"=>false},
                                      "retention_period_type"=>{"value"=>"discard_at_expiration", "modifiable"=>false},
                                      "retention_period_value"=>{"value"=>nil, "modifiable"=>false},
                                      "retention_period_unit"=>{"value"=>nil, "modifiable"=>false}
                                    }
                                  }
    )
  end

end
