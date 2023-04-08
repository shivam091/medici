# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/services/ingredients/update_service_spec.rb

require "spec_helper"

RSpec.describe Ingredients::UpdateService, type: :service do
  describe "#call" do
    let(:ingredient) { create(:ingredient) }
    let(:ingredient_attributes) { attributes_for(:ingredient, name: "New name") }
    subject { described_class.(ingredient, ingredient_attributes) }

    context "when update is successful" do
      it "updates the ingredient" do
        expect(subject.payload[:ingredient].name).to eq("New name")
        expect(subject.message).to eq("Ingredient 'New name' was successfully updated.")
      end

      include_examples "returns a success response"
    end

    context "when update fails" do
      before { allow(ingredient).to receive(:update).and_return(false) }

      it "does not update the ingredient" do
        expect(subject.payload[:ingredient].name).to eq("Fluticasone furoate")
        expect(subject.message).to eq("Ingredient could not be updated.")
      end

      include_examples "returns an error response"
    end
  end
end
