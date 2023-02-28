# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/lib/medici/regex_spec.rb

require "spec_helper"

describe ::Medici::Regex do
  using RSpec::Parameterized::TableSyntax

  describe ".only_uppercase_regex" do
    subject { described_class.only_uppercase_regex }

    where(:string, :is_valid) do
      "ABC"  | true
      "Abc"  | false
      "ABc"  | false
      "abc"  | false
    end

    with_them do
      it do
        if is_valid
          expect(string).to match(subject)
        else
          expect(string).not_to match(subject)
        end
      end
    end
  end

  describe ".only_lowercase_regex" do
    subject { described_class.only_lowercase_regex }

    where(:string, :is_valid) do
      "abc"  | true
      "Abc"  | false
      "ABc"  | false
      "ABC"  | false
    end

    with_them do
      it do
        if is_valid
          expect(string).to match(subject)
        else
          expect(string).not_to match(subject)
        end
      end
    end
  end

  describe ".boolean_true_regex" do
    subject { described_class.boolean_true_regex }

    where(:string, :is_valid) do
      "true"  | true
      "1"     | true
      "on"    | true
      "t"     | true
      "y"     | true
      "yes"   | true

      "false" | false
      "0"     | false
      "off"   | false
      "f"     | false
      "n"     | false
      "no"    | false
    end

    with_them do
      it do
        if is_valid
          expect(string).to match(subject)
        else
          expect(string).not_to match(subject)
        end
      end
    end
  end

  describe ".boolean_false_regex" do
    subject { described_class.boolean_false_regex }

    where(:string, :is_valid) do
      "false" | true
      "0"     | true
      "off"   | true
      "f"     | true
      "n"     | true
      "no"    | true
      "true"  | false
      "1"     | false
      "on"    | false
      "t"     | false
      "y"     | false
      "yes"   | false
    end

    with_them do
      it do
        if is_valid
          expect(string).to match(subject)
        else
          expect(string).not_to match(subject)
        end
      end
    end
  end

  describe ".gmt_offset_regex" do
    subject { described_class.gmt_offset_regex }

    where(:gmt_offset, :is_valid) do
      "GMT +0"      | true
      "GMT +05:30"  | true
      "UTC +05:30"  | true
      "UTC +13:40"  | true
      "UTC 05:3"    | false
      "UTC 05:30"   | false
      "UTC 25:30"   | false
      "+05:30"      | false
    end

    with_them do
      it do
        if is_valid
          expect(gmt_offset).to match(subject)
        else
          expect(gmt_offset).not_to match(subject)
        end
      end
    end
  end

  describe ".strong_password_regex" do
    subject { described_class.strong_password_regex }

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
      it do
        if is_valid
          expect(password).to match(subject)
        else
          expect(password).not_to match(subject)
        end
      end
    end
  end

  describe ".email_regex" do
    subject { described_class.email_regex }

    where(:email, :is_valid) do
      "admin@medici.com"       | true
      "admin@medici.co.uk"     | true
      "Abc"                    | false
      "ABC"                    | false
      "abC"                    | false
    end

    with_them do
      it do
        if is_valid
          expect(email).to match(subject)
        else
          expect(email).not_to match(subject)
        end
      end
    end
  end
end
