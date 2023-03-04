# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/concerns/validatable_spec.rb

require "spec_helper"

RSpec.describe Validatable do
  let(:instance) do
    Class.new do
      include ActiveModel::Model, ActiveModel::Validations, Validatable

      attr_accessor :name, :email

      validates :name, :email, presence: true

      def self.model_name
        ActiveModel::Name.new(self, nil, "ValidatableTestClass")
      end
    end.new
  end

  describe "#valid_attribute?" do
    context "when there are no validation errors" do
      it "returns true" do
        expect(instance.valid_attribute?(:name)).to be_truthy
      end
    end

    context "when there are validation errors" do
      before do
        instance.errors.add(:name, "cannot be blank")
      end

      it "returns false" do
        expect(instance.valid_attribute?(:name)).to be_falsy
      end
    end
  end

  describe "#valid_attributes?" do
    context "when all attributes are valid" do
      before do
        instance.name = "John"
        instance.email = "john@example.com"
      end

      it "returns true" do
        expect(instance.valid_attributes?(:name, :email)).to be_truthy
      end
    end

    context "when one attribute is invalid" do
      before do
        instance.name = "John"
        instance.email = nil
      end

      it "returns false" do
        expect(instance.valid_attributes?(:name, :email)).to be_falsy
      end
    end
  end

  describe "#validate_attributes!" do
    context "when all attributes are valid" do
      before do
        instance.name = "John"
        instance.email = "john@example.com"
      end

      it "does not raise an error" do
        expect { instance.validate_attributes!(:name, :email) }.not_to raise_error
      end
    end

    context "when one attribute is invalid" do
      before do
        instance.name = "John"
        instance.email = nil
      end

      it "raises an ActiveModel::ValidationError" do
        expect { instance.validate_attributes!(:name, :email) }.to raise_error(ActiveModel::ValidationError)
      end
    end
  end

end
