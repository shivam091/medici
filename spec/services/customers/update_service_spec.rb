# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/customers/update_service_spec.rb

require "spec_helper"

RSpec.describe Customers::UpdateService, type: :service do
  describe "#call" do
    let(:customer) { create(:customer) }
    let(:customer_attributes) { attributes_for(:customer, name: "New name") }
    subject { described_class.(customer, customer_attributes) }

    context "when update is successful" do
      it "updates the customer" do
        expect(subject.payload[:customer].name).to eq("New name")
        expect(subject.message).to eq("Customer 'New name' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(customer).to receive(:update).and_return(false) }

      it "does not update the customer" do
        expect(subject.payload[:customer]).to eq(customer)
        expect(subject.message).to eq("Customer could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
