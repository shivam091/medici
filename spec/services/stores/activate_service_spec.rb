# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/stores/activate_service_spec.rb

require "spec_helper"

RSpec.describe Stores::ActivateService, type: :service do
  describe "#call" do
    let(:store) { create(:store) }
    subject { described_class.(store) }

    context "when activation is successful" do
      it "activates the store" do
        expect { subject }.to change { store.reload.is_active? }.to(true)
        expect(subject.message).to eq("Store '#{store.name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before { allow(store).to receive(:activate!).and_return(false) }

      it "does not activate the store" do
        expect { subject }.not_to change { store.reload.is_active? }
        expect(subject.message).to eq("Store '#{store.name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
