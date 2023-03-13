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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:supplier]).to eq(supplier)
        expect(supplier.reload.name).to eq(supplier.name)
        expect(subject.message).to eq("Supplier '#{supplier.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(supplier).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Supplier could not be updated.")
        expect(subject.payload[:supplier]).to eq(supplier)
      end
    end
  end
end
