require 'spec_helper'

describe SendSecure::JsonMethods::ShowSafeboxes do
  include TestUtils

  let(:client) { SendSecure::JsonClient.new(api_token: "USER|489b3b1f-b411-428e-be5b-2abbace87689", enterprise_account: "acme") }
  let(:safebox_guid) { "73af62f766ee459e81f46e4f533085a4" }

  before(:each) do
    allow_any_instance_of(SendSecure::JsonClient).to receive(:get_sendsecure_endpoint).and_return("https://sendsecure.xmedius.com")
  end

  context "get_safebox_list" do
        let(:response_body) {{  "count" => 1,
                                "previous_page_url" => nil,
                                "next_page_url" => "api/v2/safeboxes?status=unread&search=test&page=2",
                                "safeboxes" => [
                                  "safebox" => {
                                    "guid" => "73af62f766ee459e81f46e4f533085a4",
                                    "user_id" => 1,
                                    "enterprise_id" => 1
                                  }
                                ]
                              }}

        it "return a safebox list when passing search parameters" do
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes.json") { |env| [ 200, {}, response_body ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          result = client.get_safebox_list(search_params: {status: "unread", search_term: "test", page: 1})
          expect(result["count"]).to eq(1)
          expect(result["previous_page_url"]).to be_nil
          expect(result["next_page_url"]).to eq("api/v2/safeboxes?status=unread&search=test&page=2")
          expect(result.has_key?("safeboxes")).to be true
          expect(result["safeboxes"].size).to eq(1)
          expect(result["safeboxes"][0]["safebox"].has_key?("guid")).to be true
        end

        it "return a safebox list when passing search url" do
          sendsecure_connection do |stubs|
            stubs.get("/api/v2/safeboxes?page=1&search=test&status=unread") { |env| [ 200, {}, response_body ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          result = client.get_safebox_list(url: "api/v2/safeboxes?status=unread&search=test&page=1")
          expect(result["count"]).to eq(1)
          expect(result["previous_page_url"]).to be_nil
          expect(result["next_page_url"]).to eq("api/v2/safeboxes?status=unread&search=test&page=2")
          expect(result.has_key?("safeboxes")).to be true
          expect(result["safeboxes"].size).to eq(1)
          expect(result["safeboxes"][0]["safebox"].has_key?("guid")).to be true
        end

        it "raise exception on failure" do
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes.json") { |env| [ 400, {}, ({ "error"=>"Invalid per_page parameter value (1001)" }).to_json ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          expect{ client.get_safebox_list(search_params: {status: "unread", search_term: "test", per_page: 1001, page: 2}) }.to raise_error SendSecure::SendSecureException, "Invalid per_page parameter value (1001)"
        end

      end

      context "get_safebox_info" do

        it "return safebox on success" do
          response_body = { "safebox" => {
                              "guid" => "73af62f766ee459e81f46e4f533085a4",
                              "security_options" => {},
                              "participants" => [],
                              "messages" => [],
                              "download_activity" => {},
                              "event_history" => []
                            }
                          }
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}.json") { |env| [ 200, {}, response_body ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          result = client.get_safebox_info(safebox_guid)
          expect(result.has_key?("safebox")).to be true
          expect(result["safebox"].has_key?("guid")).to be true
          expect(result["safebox"].has_key?("security_options")).to be true
          expect(result["safebox"].has_key?("participants")).to be true
          expect(result["safebox"].has_key?("messages")).to be true
          expect(result["safebox"].has_key?("download_activity")).to be true
          expect(result["safebox"].has_key?("event_history")).to be true
        end

        it "raise exception on failure" do
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          expect{ client.get_safebox_info(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Access denied"
        end

      end

      context "get_safebox_security_options" do

        it "return safebox security options on success" do
          response_body = { "security_options" => {
                              "security_code_length" => 4,
                              "allowed_login_attempts" => 3,
                              "allow_remember_me" => true
                            }
                          }
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/security_options.json") { |env| [ 200, {}, response_body ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          result = client.get_safebox_security_options(safebox_guid)
          expect(result.has_key?("safebox")).to be false
          expect(result.has_key?("security_options")).to be true
          expect(result["security_options"].has_key?("security_code_length")).to be true
        end

        it "raise exception on failure" do
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/security_options.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          expect{ client.get_safebox_security_options(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Access denied"
        end

      end

      context "get_safebox_messages" do

        it "return safebox messages on success" do
          response_body = { "messages" => [
                              { "note" => "note1",
                                "note_size" => 10 },
                              { "note" => "note2",
                                "note_size" => 11 }
                            ]
                          }
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/messages.json") { |env| [ 200, {}, response_body ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          result = client.get_safebox_messages(safebox_guid)
          expect(result.has_key?("safebox")).to be false
          expect(result.has_key?("messages")).to be true
          expect(result["messages"].size).to eq(2)
          expect(result["messages"][0].has_key?("note")).to be true
        end

        it "raise exception on failure" do
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/messages.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          expect{ client.get_safebox_messages(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Access denied"
        end

      end

      context "get_safebox_download_activity" do

        it "return safebox download activity on success" do
          response_body = { "download_activity" => {
                              "guests" => [
                                { "id" => "42220c777c30486e80cd3bbfa7f8e82f",
                                  "documents" => [] },
                                { "id" => "76016c0938964578b6674e96b31ac036",
                                  "documents" => [] }
                              ],
                              "owner" => {
                                "id" => 1,
                                "documents" => []
                              }
                            }
                          }
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/download_activity.json") { |env| [ 200, {}, response_body ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          result = client.get_safebox_download_activity(safebox_guid)
          expect(result.has_key?("safebox")).to be false
          expect(result.has_key?("download_activity")).to be true
          expect(result["download_activity"].has_key?("guests")).to be true
          expect(result["download_activity"]["guests"].size).to eq(2)
          expect(result["download_activity"].has_key?("owner")).to be true
        end

        it "raise exception on failure" do
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/download_activity.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          expect{ client.get_safebox_download_activity(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Access denied"
        end

      end

      context "get_safebox_event_history" do

        it "return safebox event history on success" do
          response_body = { "event_history" => [
                              { "type" => "42220c777c30486e80cd3bbfa7f8e82f",
                                "date" => [],
                                "metadata" => {},
                                "message" => "SafeBox created by john.smith@example.com with 0 attachment(s) from 0.0.0.0 for john.smith@example.com" }
                            ]
                          }
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/event_history.json") { |env| [ 200, {}, response_body ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          result = client.get_safebox_event_history(safebox_guid)
          expect(result.has_key?("safebox")).to be false
          expect(result.has_key?("event_history")).to be true
          expect(result["event_history"].size).to eq(1)
          expect(result["event_history"][0].has_key?("metadata")).to be true
        end

        it "raise exception on failure" do
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/event_history.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          expect{ client.get_safebox_event_history(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Access denied"
        end

      end

      context "get_safebox_participants" do

        it "return safebox participants on success" do
          response_body = { "participants" => [
                              { "id" => "7a3c51e00a004917a8f5db807180fcc5",
                                "guest_options" => {} },
                              { "id" => "1",
                                "role"=>"owner" }
                            ]
                          }
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/participants.json") { |env| [ 200, {}, response_body ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          result = client.get_safebox_participants(safebox_guid)
          expect(result.has_key?("safebox")).to be false
          expect(result.has_key?("participants")).to be true
          expect(result["participants"].size).to eq(2)
          expect(result["participants"][0].has_key?("guest_options")).to be true
          expect(result["participants"][1].has_key?("guest_options")).to be false
        end

        it "raise exception on failure" do
          sendsecure_connection do |stubs|
            stubs.get("api/v2/safeboxes/#{safebox_guid}/participants.json") { |env| [ 403, {}, ({ message: "Access denied" }).to_json ]}
          end
          allow_any_instance_of(SendSecure::JsonClient).to receive(:sendsecure_connection).and_return(sendsecure_connection)
          expect{ client.get_safebox_participants(safebox_guid) }.to raise_error SendSecure::SendSecureException, "Access denied"
        end

      end

end