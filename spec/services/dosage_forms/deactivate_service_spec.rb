# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/dosage_forms/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe DosageForms::DeactivateService, type: :service do
  describe "#call" do
    let(:dosage_form) { create(:dosage_form, :active) }
    subject { described_class.(dosage_form) }

    context "when deactivation is successful" do
      it "deactivates the dosage form" do
        expect { subject }.to change { dosage_form.reload.is_active? }.to(false)
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before { allow(dosage_form).to receive(:deactivate!).and_return(false) }

      it "does not deactivate the dosage form" do
        expect { subject }.not_to change { dosage_form.reload.is_active? }
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
