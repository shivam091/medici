# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/validators/uppercase_validator_spec.rb

require "spec_helper"

RSpec.describe UppercaseValidator do
  using RSpec::Parameterized::TableSyntax

  context "when custom error message is not provided" do
    subject do
      Class.new do
        include ActiveModel::Model
        include ActiveModel::Validations
        attr_accessor :iso_code

        validates :iso_code, uppercase: true

        def self.model_name
          ActiveModel::Name.new(self, nil, "UppercaseTestClass")
        end
      end.new
    end

    where(:iso_code, :is_valid) do
      "abc"       | false
      "aaa"       | false
      "Abc"       | false
      "ABC"       | true
      "abC"       | false
    end

    with_them do
      it "only accepts uppercase characters" do
        subject.iso_code = iso_code
        expect(subject.valid?).to eq(is_valid)
      end
    end
  end
end
