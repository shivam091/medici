# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/suppliers/activate_service_spec.rb

require "spec_helper"

RSpec.describe Suppliers::ActivateService, type: :service do
  describe "#call" do
    let(:supplier) { create(:supplier) }
    subject { described_class.(supplier) }

    context "when activation is successful" do
      it "activates the supplier" do
        expect { subject }.to change { supplier.reload.is_active? }.to(true)
        expect(subject.message).to eq("Supplier '#{supplier.name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before { allow(supplier).to receive(:activate!).and_return(false) }

      it "does not activate the supplier" do
        expect { subject }.not_to change { supplier.reload.is_active? }
        expect(subject.message).to eq("Supplier '#{supplier.name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
