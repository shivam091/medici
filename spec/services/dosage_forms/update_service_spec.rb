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
      it "returns a success response" do
        expect(subject).to be_success
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
        expect(dosage_form.reload.name).to eq(dosage_form.name)
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' was successfully updated.")
      end
    end

    context "when update fails" do
      it "returns an error response" do
        allow(dosage_form).to receive(:update).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Dosage form could not be updated.")
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
      end
    end
  end
end
