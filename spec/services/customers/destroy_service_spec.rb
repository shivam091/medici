# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/customers/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Customers::DestroyService, type: :service do
  describe "#call" do
    let!(:customer) { create(:customer) }
    subject { described_class.(customer) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::Customer

      it "sets flash message" do
        expect(subject.message).to eq("Customer 'Customer' was successfully destroyed.")
        expect(::Customer.find_by(id: customer.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(customer).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::Customer

      it "sets flash message" do
        expect(subject.message).to eq("Customer 'Customer' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
