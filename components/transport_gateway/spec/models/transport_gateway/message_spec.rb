require 'rails_helper'

module TransportGateway
  RSpec.describe Message, type: :model do

    let(:from)  { "foo@example.com" }
    let(:to)    { "bar@example.com" }
    let(:body)  { "lorum ipsum" }

    context ".new" do
      context "with no arguments" do

        it "should raise an argument error" do
          expect{ Message.new() }.to raise_error(ArgumentError) 
        end
      end

      context "with a unparseable URI in 'to' argument" do
        let(:invalid_uri)  { 7463 }

        it "should raise Invalid URI error" do
          expect{ Message.new(from, invalid_uri, body) }.to raise_error(URI::InvalidURIError) 
        end
      end

      context "with empty 'from' argument" do
        it "should not raise an error" do
          expect{Message.new("", to, body)}.not_to raise_error 
        end
      end

      context "with valid arguments" do
        let(:params)  {valid_params}
        let(:message_with_valid_arguments) { Message.new(from, to, body) }
        let(:to_uri)  { URI.parse(to) }

        it "should not raise an error" do
          expect{message_with_valid_arguments}.not_to raise_error 
        end

        it "should set the instance vars" do
          expect(message_with_valid_arguments.from).to eq from
          expect(message_with_valid_arguments.body).to eq body
        end

        it "should cast the 'to' argument as a URI" do
          expect(message_with_valid_arguments.to).to eq to_uri
        end

      end

    end

  end
end
