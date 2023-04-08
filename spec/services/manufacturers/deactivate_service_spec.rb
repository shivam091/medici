# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/manufacturers/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Manufacturers::DeactivateService, type: :service do
  describe "#call" do
    let(:manufacturer) { create(:manufacturer, :active) }
    subject { described_class.(manufacturer) }

    context "when deactivation is successful" do
      it "deactivates the manufacturer" do
        expect { subject }.to change { manufacturer.reload.is_active? }.to(false)
        expect(subject.message).to eq("Manufacturer '#{manufacturer.name}' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before { allow(manufacturer).to receive(:deactivate!).and_return(false) }

      it "does not deactivate the manufacturer" do
        expect { subject }.not_to change { manufacturer.reload.is_active? }
        expect(subject.message).to eq("Manufacturer '#{manufacturer.name}' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
