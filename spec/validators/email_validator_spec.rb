# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/validators/email_validator_spec.rb

require "spec_helper"

RSpec.describe EmailValidator do
  using RSpec::Parameterized::TableSyntax

  context "when custom error message is not provided" do
    subject do
      Class.new do
        include ActiveModel::Model
        include ActiveModel::Validations
        attr_accessor :email

        validates :email, email: true

        def self.model_name
          ActiveModel::Name.new(self, nil, "EmailValidatorTestClass")
        end
      end.new
    end

    where(:email, :is_valid) do
      "admin@medici.com"       | true
      "admin@medici.co.uk"     | true
      "Abc"                    | false
      "ABC"                    | false
      "abC"                    | false
    end

    with_them do
      it "only accepts valid email" do
        subject.email = email

        expect(subject.valid?).to eq(is_valid)
      end
    end
  end
end
