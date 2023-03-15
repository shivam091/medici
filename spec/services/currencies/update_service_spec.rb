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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:currency]).to eq(currency)
        expect(currency.reload.name).to eq(currency.name)
        expect(subject.message).to eq("Currency '#{currency.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      before do
        allow(currency).to receive(:update).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Currency could not be updated.")
        expect(subject.payload[:currency]).to eq(currency)
      end
    end
  end
end
