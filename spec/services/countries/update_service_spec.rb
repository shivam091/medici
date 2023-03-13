# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/countries/update_service_spec.rb

require "spec_helper"

RSpec.describe Countries::UpdateService, type: :service do
  describe "#call" do
    let(:country) { create(:country) }
    let(:country_attributes) { attributes_for(:country, name: "New name") }
    subject { described_class.(country, country_attributes) }

    context "when update is successful" do
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:country]).to eq(country)
        expect(country.reload.name).to eq(country.name)
        expect(subject.message).to eq("Country '#{country.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(country).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Country could not be updated.")
        expect(subject.payload[:country]).to eq(country)
      end
    end
  end
end
