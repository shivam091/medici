# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/stores/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Stores::DeactivateService, type: :service do
  describe "#call" do
    let(:store) { create(:store, :active) }
    subject { described_class.(store) }

    context "when deactivation is successful" do
      it "deactivates the store" do
        expect { subject }.to change { store.reload.is_active? }.to(false)
        expect(subject.message).to eq("Store '#{store.name}' was successfully deactivated.")
      end

      include_examples "returns a success response"
    end

    context "when deactivation fails" do
      before { allow(store).to receive(:deactivate!).and_return(false) }

      it "does not deactivate the store" do
        expect { subject }.not_to change { store.reload.is_active? }
        expect(subject.message).to eq("Store '#{store.name}' could not be deactivated.")
      end

      include_examples "returns an error response"
    end
  end
end
