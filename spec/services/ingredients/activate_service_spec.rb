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
      end

      it "returns an success response" do
        expect(subject).to be_success
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' was successfully activated.")
      end
    end

    context "when activation fails" do
      before do
        allow(ingredient).to receive(:activate!).and_return(false)
      end

      it "does not activate the ingredient" do
        expect { subject }.not_to change { ingredient.reload.is_active? }
      end

      it "returns an error response" do
        expect(subject).to be_error
        expect(subject.message).to eq("Ingredient '#{ingredient.name}' could not be activated.")
      end
    end
  end
end
