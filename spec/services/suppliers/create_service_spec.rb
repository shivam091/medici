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
      it "sets flash message" do
        expect(subject.message).to eq("Supplier 'Supplier' was successfully created.")
      end

      include_examples "creates a new object", ::Supplier

      include_examples "returns a success response"
    end

    context "when supplier is invalid" do
      let(:supplier_attributes) { attributes_for(:supplier, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Supplier could not be created.")
      end

      include_examples "does not change count of objects", ::Supplier

      include_examples "returns an error response"
    end
  end
end
