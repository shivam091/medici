# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/medicines/activate_service_spec.rb

require "spec_helper"

RSpec.describe Medicines::ActivateService, type: :service do
  describe "#call" do
    let(:medicine) { create(:medicine, :with_user) }
    subject { described_class.(medicine) }

    context "when activation is successful" do
      it "activates the medicine" do
        expect { subject }.to change { medicine.reload.is_active? }.to(true)
        expect(subject.message).to eq("Medicine '#{medicine.reference_code} (#{medicine.name})' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before { allow(medicine).to receive(:activate!).and_return(false) }

      it "does not activate the medicine" do
        expect { subject }.not_to change { medicine.reload.is_active? }
        expect(subject.message).to eq("Medicine '#{medicine.reference_code} (#{medicine.name})' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
