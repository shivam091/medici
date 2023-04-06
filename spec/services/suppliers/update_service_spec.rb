# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/suppliers/update_service_spec.rb

require "spec_helper"

RSpec.describe Suppliers::UpdateService, type: :service do
  describe "#call" do
    let(:supplier) { create(:supplier) }
    let(:supplier_attributes) { attributes_for(:supplier, name: "New name") }
    subject { described_class.(supplier, supplier_attributes) }

    context "when update is successful" do
      it "updates the supplier" do
        expect(subject.payload[:supplier].name).to eq("New name")
        expect(subject.message).to eq("Supplier 'New name' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(supplier).to receive(:update).and_return(false) }

      it "does not update the supplier" do
        expect(subject.payload[:supplier]).to eq(supplier)
        expect(subject.message).to eq("Supplier could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
