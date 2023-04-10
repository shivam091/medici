# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/customers/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Customers::DeactivateService, type: :service do
  describe "#call" do
    let(:customer) { create(:customer, :active) }
    subject { described_class.(customer) }

    context "when deactivation is successful" do
      it "deactivates the customer" do
        expect { subject }.to change { customer.reload.is_active? }.to(false)
        expect(subject.message).to eq("Customer '#{customer.name}' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before { allow(customer).to receive(:deactivate!).and_return(false) }

      it "does not deactivate the customer" do
        expect { subject }.not_to change { customer.reload.is_active? }
        expect(subject.message).to eq("Customer '#{customer.name}' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
