# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/currencies/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Currencies::DestroyService, type: :service do
  describe "#call" do
    let(:currency) { create(:currency) }
    subject { described_class.(currency) }

    context "when destroy is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Currency '#{currency.name}' was successfully destroyed.")
        expect(subject.payload[:currency]).to eq(currency)
        expect(::Currency.find_by(id: currency.id)).to be_nil
      end
    end

    context "when destroy fails" do
      before do
        allow(currency).to receive(:destroy).and_return(false)
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Currency '#{currency.name}' could not be destroyed.")
        expect(subject.payload[:currency]).to eq(currency)
      end

      include_examples "does not change count of objects", ::Currency
    end
  end
end
