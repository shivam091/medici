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
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Packing type '#{packing_type.name}' was successfully activated.")
        expect(subject.payload[:packing_type]).to eq(packing_type)
      end
    end

    context "when activation fails" do
      it "returns an error response" do
        allow(packing_type).to receive(:activate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Packing type '#{packing_type.name}' could not be activated.")
        expect(subject.payload[:packing_type]).to eq(packing_type)
      end
    end
  end
end
