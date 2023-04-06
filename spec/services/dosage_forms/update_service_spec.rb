# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/dosage_forms/update_service_spec.rb

require "spec_helper"

RSpec.describe DosageForms::UpdateService, type: :service do
  describe "#call" do
    let(:dosage_form) { create(:dosage_form) }
    let(:dosage_form_attributes) { attributes_for(:dosage_form, name: "New name") }
    subject { described_class.(dosage_form, dosage_form_attributes) }

    context "when update is successful" do
      it "updates the dosage form" do
        expect(subject.payload[:dosage_form].name).to eq("New name")
        expect(subject.message).to eq("Dosage form 'New name' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(dosage_form).to receive(:update).and_return(false) }

      it "does not update the dosage form" do
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
        expect(subject.message).to eq("Dosage form could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
