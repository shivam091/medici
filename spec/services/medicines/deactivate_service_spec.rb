# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicines/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Medicines::DeactivateService, type: :service do
  describe "#call" do
    let(:medicine) { create(:medicine, :with_user, :active) }
    subject { described_class.(medicine) }

    context "when deactivation is successful" do
      it "deactivates the medicine" do
        expect { subject }.to change { medicine.reload.is_active? }.to(false)
        expect(subject.message).to eq("Medicine '#{medicine.reference_code} (#{medicine.name})' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before { allow(medicine).to receive(:deactivate!).and_return(false) }

      it "does not deactivate the medicine" do
        expect { subject }.not_to change { medicine.reload.is_active? }
        expect(subject.message).to eq("Medicine '#{medicine.reference_code} (#{medicine.name})' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
