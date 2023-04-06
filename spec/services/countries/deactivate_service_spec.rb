# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/countries/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Countries::DeactivateService, type: :service do
  describe "#call" do
    let(:country) { create(:country, :active) }
    subject { described_class.(country) }

    context "when deactivation is successful" do
      it "deactivates the country" do
        expect { subject }.to change { country.reload.is_active? }.to(false)
        expect(subject.message).to eq("Country '#{country.name}' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before do
        allow(country).to receive(:deactivate!).and_return(false)
      end

      it "does not deactivate the country" do
        expect { subject }.not_to change { country.reload.is_active? }
        expect(subject.message).to eq("Country '#{country.name}' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
