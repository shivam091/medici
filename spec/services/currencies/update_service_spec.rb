# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/currencies/update_service_spec.rb

require "spec_helper"

RSpec.describe Currencies::UpdateService, type: :service do
  describe "#call" do
    let(:currency) { create(:currency) }
    let(:currency_attributes) { attributes_for(:currency, name: "New name") }
    subject { described_class.(currency, currency_attributes) }

    context "when update is successful" do
      it "updates the currency" do
        expect(subject.payload[:currency].name).to eq("New name")
        expect(subject.message).to eq("Currency 'New name' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(currency).to receive(:update).and_return(false) }

      it "does not update the currency" do
        expect(subject.payload[:currency]).to eq(currency)
        expect(subject.message).to eq("Currency could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
