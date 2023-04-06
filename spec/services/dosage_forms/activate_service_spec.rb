# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/dosage_forms/activate_service_spec.rb

require "spec_helper"

RSpec.describe DosageForms::ActivateService, type: :service do
  describe "#call" do
    let(:dosage_form) { create(:dosage_form) }
    subject { described_class.(dosage_form) }

    context "when activation is successful" do
      it "activates the dosage form" do
        expect { subject }.to change { dosage_form.reload.is_active? }.to(true)
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before do
        allow(dosage_form).to receive(:activate!).and_return(false)
      end

      it "does not activate the dosage form" do
        expect { subject }.not_to change { dosage_form.reload.is_active? }
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
