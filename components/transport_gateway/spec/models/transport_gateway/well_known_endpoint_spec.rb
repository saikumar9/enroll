require 'rails_helper'

module TransportGateway
  RSpec.describe WellKnownEndpoint, type: :model, :dbclean => :after_each do

    let(:title)        { "House of Representatives member invoice outbound" }  
    let(:key)          { :hr_members_invoice_outbound }  
    let(:site_key)     { :dchbx }
    let(:market_kind)  { :aca_congress } 
    let(:uri)          { "sftp://blah.com/folder"}


    let(:valid_params) do
      {
        title: title,
        site_key: site_key,
        key: key,
        market_kind: market_kind,
        uri: uri,
      }
    end

    context "with no arguments" do
      let(:params)  {{}}

      it "should instantiate a WellKnownEndpoint instance" do
        expect(WellKnownEndpoint.new(**params)).to be_an_instance_of(WellKnownEndpoint)
      end
    end

    context "with no 'title' argument" do
      let(:params)  { valid_params.except(:title) }

      it "should not be valid" do
        expect(WellKnownEndpoint.new(**params)).to_not be_valid 
      end
    end

    context "with valid arguments" do
      let(:params)  { valid_params }

      it "should be valid" do
        expect(WellKnownEndpoint.new(**params)).to be_valid
      end

      it "should save" do
        expect(WellKnownEndpoint.new(**params).save).to be_truthy
      end

      it "should be found using endpoint_key scope" do
        WellKnownEndpoint.create!(**params)
        endpoints = WellKnownEndpoint.find_by_endpoint_key(key)

        expect(endpoints.size).to eq 1
        expect(endpoints.first.title).to eq title
      end
    end

  end
end
