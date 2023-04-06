# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/packing_types/update_service_spec.rb

require "spec_helper"

RSpec.describe PackingTypes::UpdateService, type: :service do
  describe "#call" do
    let(:packing_type) { create(:packing_type) }
    let(:packing_type_attributes) { attributes_for(:packing_type, name: "New name") }
    subject { described_class.(packing_type, packing_type_attributes) }

    context "when update is successful" do
      it "updates the packing type" do
        expect(subject.payload[:packing_type].name).to eq("New name")
        expect(subject.message).to eq("Packing type '#{packing_type.name}' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(packing_type).to receive(:update).and_return(false) }

      it "does not update the packing type" do
        expect(subject.payload[:packing_type]).to eq(packing_type)
        expect(subject.message).to eq("Packing type could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
