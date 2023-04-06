# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/currencies/activate_service_spec.rb

require "spec_helper"

RSpec.describe Currencies::ActivateService, type: :service do
  describe "#call" do
    let(:currency) { create(:currency) }
    subject { described_class.(currency) }

    context "when activation is successful" do
      it "activates the currency" do
        expect { subject }.to change { currency.reload.is_active? }.to(true)
        expect(subject.message).to eq("Currency '#{currency.name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before { allow(currency).to receive(:activate!).and_return(false) }

      it "does not activate the currency" do
        expect { subject }.not_to change { currency.reload.is_active? }
        expect(subject.message).to eq("Currency '#{currency.name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
