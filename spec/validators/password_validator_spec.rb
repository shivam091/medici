# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/validators/password_validator_spec.rb

require "spec_helper"

RSpec.describe PasswordValidator do
  using RSpec::Parameterized::TableSyntax

  subject do
    Class.new do
      include ActiveModel::Model
      include ActiveModel::Validations
      attr_accessor :password

      validates :password, password: true

      def self.model_name
        ActiveModel::Name.new(self, nil, "PasswordTestClass")
      end
    end.new
  end

  where(:password, :is_valid) do
    "Test@123"           | true
    "Test@1234"          | true
    "test@123"           | false
    "test"               | false
    "test@"              | false
    "Test@12"            | false
    "TestTest@1232332"   | false
  end

  with_them do
    it "only accepts valid password" do
      subject.password = password

      expect(subject.valid?).to eq(is_valid)
    end
  end
end
