# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/customers/create_service_spec.rb

require "spec_helper"

RSpec.describe Customers::CreateService, type: :service do
  let(:customer_attributes) { attributes_for(:customer) }
  subject { described_class.(customer_attributes) }

  describe "#call" do
    context "when customer is valid" do
      it "sets flash message" do
        expect(subject.message).to eq("Customer 'Customer' was successfully created.")
      end

      include_examples "creates a new object", ::Customer

      include_examples "returns a success response"
    end

    context "when customer is invalid" do
      let(:customer_attributes) { attributes_for(:customer, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Customer could not be created.")
      end

      include_examples "does not change count of objects", ::Customer

      include_examples "returns an error response"
    end
  end
end
