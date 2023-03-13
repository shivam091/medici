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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:manufacturer]).to eq(manufacturer)
        expect(manufacturer.reload.name).to eq(manufacturer.name)
        expect(subject.message).to eq("Manufacturer '#{manufacturer.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(manufacturer).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Manufacturer could not be updated.")
        expect(subject.payload[:manufacturer]).to eq(manufacturer)
      end
    end
  end
end
