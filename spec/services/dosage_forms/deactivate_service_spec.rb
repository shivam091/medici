# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/dosage_forms/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe DosageForms::DeactivateService, type: :service do
  describe "#call" do
    let(:dosage_form) { create(:dosage_form) }
    subject { described_class.(dosage_form) }

    context "when deactivation is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' was successfully deactivated.")
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
      end
    end

    context "when deactivation fails" do
      it "returns an error response" do
        allow(dosage_form).to receive(:deactivate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' could not be deactivated.")
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
      end
    end
  end
end
