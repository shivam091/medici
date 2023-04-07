# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/activate_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::ActivateService, type: :service do
  describe "#call" do
    let(:ingredient) { create(:ingredient) }
    subject { described_class.(ingredient) }

    context "when activation is successful" do
      it "activates the ingredient" do
        expect { subject }.to change { ingredient.reload.is_active? }.to(true)
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' was successfully activated.")
      end

      include_examples "returns a success response"
    end

    context "when activation fails" do
      before { allow(ingredient).to receive(:activate!).and_return(false) }

      it "does not activate the ingredient" do
        expect { subject }.not_to change { ingredient.reload.is_active? }
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' could not be activated.")
      end

      include_examples "returns an error response"
    end
  end
end
