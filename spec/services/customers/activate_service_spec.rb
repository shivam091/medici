# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/customers/activate_service_spec.rb

require "spec_helper"

RSpec.describe Customers::ActivateService, type: :service do
  describe "#call" do
    let(:customer) { create(:customer) }
    subject { described_class.(customer) }

    context "when activation is successful" do
      it "activates the customer" do
        expect { subject }.to change { customer.reload.is_active? }.to(true)
        expect(subject.message).to eq("Customer '#{customer.name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before { allow(customer).to receive(:activate!).and_return(false) }

      it "does not activate the customer" do
        expect { subject }.not_to change { customer.reload.is_active? }
        expect(subject.message).to eq("Customer '#{customer.name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
