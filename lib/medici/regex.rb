# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module Medici
  module Regex
    extend self

    def boolean_true_regex
      @boolean_true_regex ||= /^(true|t|yes|y|1|on)$/i.freeze
    end

    def boolean_false_regex
      @boolean_false_regex ||= /^(false|f|no|n|0|off)$/i.freeze
    end

    def only_uppercase_regex
      @only_uppercase_regex ||= /\A[A-Z]*\z/.freeze
    end

    def only_lowercase_regex
      @only_lowercase_regex ||= /\A[a-z]*\z/.freeze
    end

    def strong_password_regex
      @strong_password_regex ||= /\A^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,15}$\z/.freeze
    end

    def email_regex
      @email_regex ||= /^[a-zA-Z0-9_\.\+\-]+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-.]+$/i.freeze
    end

    def gmt_offset_regex
      @gmt_offset_regex ||= /\A(UTC|GMT){1}\s[+-]([01]\d?|2[0-4])(:?[0-5]\d)?\z/.freeze
    end
  end
end
