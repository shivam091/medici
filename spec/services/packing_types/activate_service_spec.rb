# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/packing_types/activate_service_spec.rb

require "spec_helper"

RSpec.describe PackingTypes::ActivateService, type: :service do
  describe "#call" do
    let(:packing_type) { create(:packing_type) }
    subject { described_class.(packing_type) }

    context "when activation is successful" do
      it "activates the packing type" do
        expect { subject }.to change { packing_type.reload.is_active? }.to(true)
        expect(subject.message).to eq("Packing type '#{packing_type.name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before do
        allow(packing_type).to receive(:activate!).and_return(false)
      end

      it "does not activate the packing type" do
        expect { subject }.not_to change { packing_type.reload.is_active? }
        expect(subject.message).to eq("Packing type '#{packing_type.name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
