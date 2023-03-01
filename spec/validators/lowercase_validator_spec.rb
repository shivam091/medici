# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/validators/lowercase_validator_spec.rb

require "spec_helper"

RSpec.describe LowercaseValidator do
  using RSpec::Parameterized::TableSyntax

  context "when custom error message is not provided" do
    subject do
      Class.new do
        include ActiveModel::Model
        include ActiveModel::Validations
        attr_accessor :abbreviation

        validates :abbreviation, lowercase: true

        def self.model_name
          ActiveModel::Name.new(self, nil, "LowercaseTestClass")
        end
      end.new
    end

    where(:abbreviation, :is_valid) do
      "abc"       | true
      "aaa"       | true
      "Abc"       | false
      "ABC"       | false
      "abC"       | false
    end

    with_them do
      it "only accepts lowercase characters" do
        subject.abbreviation = abbreviation

        expect(subject.valid?).to eq(is_valid)
      end
    end
  end
end
