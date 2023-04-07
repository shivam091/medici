# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/packing_types/destroy_service_spec.rb

require "spec_helper"

RSpec.describe PackingTypes::DestroyService, type: :service do
  describe "#call" do
    let!(:packing_type) { create(:packing_type) }
    subject { described_class.(packing_type) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::PackingType

      it "sets flash message" do
        expect(subject.message).to eq("Packing type 'Bottles' was successfully destroyed.")
        expect(::PackingType.find_by(id: packing_type.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(packing_type).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::PackingType

      it "sets flash message" do
        expect(subject.message).to eq("Packing type 'Bottles' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
