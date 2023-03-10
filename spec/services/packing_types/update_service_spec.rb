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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:packing_type]).to eq(packing_type)
        expect(packing_type.reload.name).to eq(packing_type.name)
        expect(subject.message).to eq("Packing type '#{packing_type.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(packing_type).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Packing type could not be updated.")
        expect(subject.payload[:packing_type]).to eq(packing_type)
      end
    end
  end
end
