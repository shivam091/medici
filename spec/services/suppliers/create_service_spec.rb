# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/suppliers/create_service_spec.rb

require "spec_helper"

RSpec.describe Suppliers::CreateService, type: :service do
  let(:supplier_attributes) { attributes_for(:supplier) }
  subject { described_class.(supplier_attributes) }

  describe "#call" do
    context "when supplier is valid" do
      it "returns a success response with the supplier" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Supplier '#{subject.payload[:supplier].name}' was successfully created.")
        expect(subject.payload).to include(supplier: instance_of(::Supplier))
      end

      include_examples "creates a new object", ::Supplier
    end

    context "when supplier is invalid" do
      let(:supplier_attributes) { attributes_for(:supplier, name: "") }

      it "returns an error response with the supplier" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Supplier could not be created.")
        expect(subject.payload).to include(supplier: instance_of(::Supplier))
      end

      include_examples "does not change count of objects", ::Supplier
    end
  end
end
