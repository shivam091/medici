# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/suppliers/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Suppliers::DeactivateService, type: :service do
  describe "#call" do
    let(:supplier) { create(:supplier, :active) }
    subject { described_class.(supplier) }

    context "when deactivation is successful" do
      it "deactivates the supplier" do
        expect { subject }.to change { supplier.reload.is_active? }.to(false)
        expect(subject.message).to eq("Supplier '#{supplier.name}' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before { allow(supplier).to receive(:deactivate!).and_return(false) }

      it "does not deactivate the supplier" do
        expect { subject }.not_to change { supplier.reload.is_active? }
        expect(subject.message).to eq("Supplier '#{supplier.name}' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
