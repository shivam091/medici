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
      it "returns a success response with the customer" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Customer '#{subject.payload[:customer].name}' was successfully created.")
        expect(subject.payload).to include(customer: instance_of(::Customer))
      end

      include_examples "creates a new object", ::Customer
    end

    context "when customer is invalid" do
      let(:customer_attributes) { attributes_for(:customer, name: "") }

      it "returns an error response with the customer" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Customer could not be created.")
        expect(subject.payload).to include(customer: instance_of(::Customer))
      end

      include_examples "does not change count of objects", ::Customer
    end
  end
end
