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
      it "updates the country" do
        expect(subject.payload[:country].name).to eq("New name")
        expect(subject.message).to eq("Country '#{country.name}' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(country).to receive(:update).and_return(false) }

      it "does not update the country" do
        expect(subject.payload[:country]).to eq(country)
        expect(subject.message).to eq("Country could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
