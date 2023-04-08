# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/manufacturers/activate_service_spec.rb

require "spec_helper"

RSpec.describe Manufacturers::ActivateService, type: :service do
  describe "#call" do
    let(:manufacturer) { create(:manufacturer) }
    subject { described_class.(manufacturer) }

    context "when activation is successful" do
      it "activates the manufacturer" do
        expect { subject }.to change { manufacturer.reload.is_active? }.to(true)
        expect(subject.message).to eq("Manufacturer '#{manufacturer.name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before { allow(manufacturer).to receive(:activate!).and_return(false) }

      it "does not activate the manufacturer" do
        expect { subject }.not_to change { manufacturer.reload.is_active? }
        expect(subject.message).to eq("Manufacturer '#{manufacturer.name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
