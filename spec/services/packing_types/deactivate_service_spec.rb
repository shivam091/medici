# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/packing_types/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe PackingTypes::DeactivateService, type: :service do
  describe "#call" do
    let(:packing_type) { create(:packing_type, :active) }
    subject { described_class.(packing_type) }

    context "when deactivation is successful" do
      it "deactivates the packing type" do
        expect { subject }.to change { packing_type.reload.is_active? }.to(false)
      end

      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Packing type '#{packing_type.name}' was successfully deactivated.")
      end
    end

    context "when deactivation fails" do
      before do
        allow(packing_type).to receive(:deactivate!).and_return(false)
      end

      it "does not deactivate the packing type" do
        expect { subject }.not_to change { packing_type.reload.is_active? }
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Packing type '#{packing_type.name}' could not be deactivated.")
      end
    end
  end
end
