require 'spec_helper'
require 'support/clients/base_elementary_client'
require 'support/clients/elementary_client_using_anti_pattern'

def sendAndVerify(msg)
  response = client.invoke_echo_service(Elementary::Rspec::String.new(:data => msg))
  expect(response).to be_rejected
  expect(response.reason.class).to be Elementary::Middleware::HttpStatusError
  expect(response.reason.message).to include("returned an HTTP response status of 503, so an exception was raised.")
end

# This test requires ha-proxy to be listening at localhost:8080, but no real rpc to be available
describe ElementaryClientUsingAntiPattern, "blah", :type => :integration do
  subject (:client) {ElementaryClientUsingAntiPattern.new()}
  describe "#initialize" do
    it "creates a connection" do
      expect(client.connection).not_to be_nil
    end
  end
  describe "#invoke_service" do
    context 'with http connection returning error code 503' do
      it "invokes echo service" do
        sendAndVerify('rspec1')
      end
    end
  end
end