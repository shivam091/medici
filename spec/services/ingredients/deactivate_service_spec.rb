# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/deactivate_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::DeactivateService, type: :service do
  describe "#call" do
    let(:ingredient) { create(:ingredient, :active) }
    subject { described_class.(ingredient) }

    context "when deactivation is successful" do
      it "deactivates the ingredient" do
        expect { subject }.to change { ingredient.reload.is_active? }.to(false)
      end

      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' was successfully deactivated.")
      end
    end

    context "when deactivation fails" do
      before do
        allow(ingredient).to receive(:deactivate!).and_return(false)
      end

      it "does not deactivate the ingredient" do
        expect { subject }.not_to change { ingredient.reload.is_active? }
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' could not be deactivated.")
      end
    end
  end
end
