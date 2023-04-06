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
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' was successfully activated.")
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
      end
    end

    context "when activation fails" do
      it "returns an error response" do
        allow(dosage_form).to receive(:activate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Dosage form '#{dosage_form.name}' could not be activated.")
        expect(subject.payload[:dosage_form]).to eq(dosage_form)
      end
    end
  end
end
