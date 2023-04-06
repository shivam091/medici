# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/currencies/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Currencies::DeactivateService, type: :service do
  describe "#call" do
    let(:currency) { create(:currency, :active) }
    subject { described_class.(currency) }

    context "when deactivation is successful" do
      it "deactivates the currency" do
        expect { subject }.to change { currency.reload.is_active? }.to(false)
      end

      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Currency '#{currency.name}' was successfully deactivated.")
      end
    end

    context "when deactivation fails" do
      before do
        allow(currency).to receive(:deactivate!).and_return(false)
      end

      it "does not deactivate the currency" do
        expect { subject }.not_to change { currency.reload.is_active? }
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Currency '#{currency.name}' could not be deactivated.")
      end
    end
  end
end
