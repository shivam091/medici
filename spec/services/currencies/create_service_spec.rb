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
      it "sets flash message" do
        expect(subject.message).to eq("Currency 'Indian rupee' was successfully created.")
      end

      include_examples "creates a new object", ::Currency

      include_examples "returns a success response"
    end

    context "when currency is invalid" do
      let(:currency_attributes) { attributes_for(:currency, name: "") }

      it "sets flash message" do
        expect(subject.message).to eq("Currency could not be created.")
      end

      include_examples "does not change count of objects", ::Currency

      include_examples "returns an error response"
    end
  end
end
