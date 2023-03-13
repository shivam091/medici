# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/currencies/create_service_spec.rb

require "spec_helper"

RSpec.describe Currencies::CreateService, type: :service do
  let(:currency_attributes) { attributes_for(:currency) }
  subject { described_class.(currency_attributes) }

  describe "#call" do
    context "when currency is valid" do
      it "returns a success response with the currency" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_success
        expect(subject.message).to eq("Currency '#{subject.payload[:currency].name}' was successfully created.")
        expect(subject.payload).to include(currency: instance_of(::Currency))
      end

      include_examples "creates a new object", ::Currency
    end

    context "when currency is invalid" do
      let(:currency_attributes) { attributes_for(:currency, name: "") }

      it "returns an error response with the currency" do
        expect(subject).to be_a(ServiceResponse)
        expect(subject).to be_error
        expect(subject.message).to eq("Currency could not be created.")
        expect(subject.payload).to include(currency: instance_of(::Currency))
      end

      include_examples "does not change count of objects", ::Currency
    end
  end
end
