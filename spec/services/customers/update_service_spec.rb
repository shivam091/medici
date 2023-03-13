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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:customer]).to eq(customer)
        expect(customer.reload.name).to eq(customer.name)
        expect(subject.message).to eq("Customer '#{customer.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(customer).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Customer could not be updated.")
        expect(subject.payload[:customer]).to eq(customer)
      end
    end
  end
end
