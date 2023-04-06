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
      end

      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' was successfully deactivated.")
      end
    end

    context "when deactivation fails" do
      before do
        allow(dosage_form).to receive(:deactivate!).and_return(false)
      end

      it "does not deactivate the dosage form" do
        expect { subject }.not_to change { dosage_form.reload.is_active? }
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' could not be deactivated.")
      end
    end
  end
end
