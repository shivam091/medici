# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/packing_types/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe PackingTypes::DeactivateService, type: :service do
  describe "#call" do
    let(:packing_type) { create(:packing_type) }
    subject { described_class.(packing_type) }

    context "when deactivation is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Packing type '#{packing_type.name}' was successfully deactivated.")
        expect(subject.payload[:packing_type]).to eq(packing_type)
      end
    end

    context "when deactivation fails" do
      it "returns an error response" do
        allow(packing_type).to receive(:deactivate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Packing type '#{packing_type.name}' could not be deactivated.")
        expect(subject.payload[:packing_type]).to eq(packing_type)
      end
    end
  end
end
