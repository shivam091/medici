# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::DeactivateService, type: :service do
  describe "#call" do
    let(:ingredient) { create(:ingredient) }
    subject { described_class.(ingredient) }

    context "when deactivation is successful" do
      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' was successfully deactivated.")
        expect(subject.payload[:ingredient]).to eq(ingredient)
      end
    end

    context "when deactivation fails" do
      it "returns an error response" do
        allow(ingredient).to receive(:deactivate!).and_return(false)

        expect(subject).to be_error
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' could not be deactivated.")
        expect(subject.payload[:ingredient]).to eq(ingredient)
      end
    end
  end
end
