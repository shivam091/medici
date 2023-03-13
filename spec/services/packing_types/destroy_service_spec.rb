# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/packing_types/destroy_service_spec.rb

require "spec_helper"

RSpec.describe PackingTypes::DestroyService, type: :service do
  describe "#call" do
    let(:packing_type) { create(:packing_type) }
    subject { described_class.(packing_type) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Packing type '#{packing_type.name}' was successfully destroyed.")
        expect(subject.payload[:packing_type]).to eq(packing_type)
        expect(::PackingType.find_by(id: packing_type.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before do
        allow(packing_type).to receive(:destroy).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Packing type '#{packing_type.name}' could not be destroyed.")
        expect(subject.payload[:packing_type]).to eq(packing_type)
      end

      include_examples "does not change count of objects", ::PackingType
    end
  end
end
