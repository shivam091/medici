# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/currencies/destroy_service_spec.rb

require "spec_helper"

RSpec.describe Currencies::DestroyService, type: :service do
  describe "#call" do
    let!(:currency) { create(:currency) }
    subject { described_class.(currency) }

    context "when destroy is successful" do
      include_examples "deletes an object", ::Currency

      it "sets flash message" do
        expect(subject.message).to eq("Currency 'Indian rupee' was successfully destroyed.")
        expect(::Currency.find_by(id: currency.id)).to be_nil
      end

      include_examples "returns a success response"
    end

    context "when destroy fails" do
      before { allow(currency).to receive(:destroy).and_return(false) }

      include_examples "does not change count of objects", ::Currency

      it "sets flash message" do
        expect(subject.message).to eq("Currency 'Indian rupee' could not be destroyed.")
      end

      include_examples "returns an error response"
    end
  end
end
