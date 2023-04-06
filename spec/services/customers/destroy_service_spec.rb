# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/customers/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Customers::DestroyService, type: :service do
  describe "#call" do
    let(:customer) { create(:customer) }
    subject { described_class.(customer) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Customer '#{customer.name}' was successfully destroyed.")
        expect(subject.payload[:customer]).to eq(customer)
        expect(::Customer.find_by(id: customer.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before { allow(customer).to receive(:destroy).and_return(false) }

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Customer '#{customer.name}' could not be destroyed.")
        expect(subject.payload[:customer]).to eq(customer)
      end

      include_examples "does not change count of objects", ::Customer
    end
  end
end
