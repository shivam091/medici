# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/manufacturers/update_service_spec.rb

require "spec_helper"

RSpec.describe Manufacturers::UpdateService, type: :service do
  describe "#call" do
    let(:manufacturer) { create(:manufacturer) }
    let(:manufacturer_attributes) { attributes_for(:manufacturer, name: "New name") }
    subject { described_class.(manufacturer, manufacturer_attributes) }

    context "when update is successful" do
      it "updates the manufacturer" do
        expect(subject.payload[:manufacturer].name).to eq("New name")
        expect(subject.message).to eq("Manufacturer 'New name' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(manufacturer).to receive(:update).and_return(false) }

      it "does not update the manufacturer" do
        expect(subject.payload[:manufacturer]).to eq(manufacturer)
        expect(subject.message).to eq("Manufacturer could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
