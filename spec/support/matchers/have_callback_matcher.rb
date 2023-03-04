# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

RSpec::Matchers.define :have_callback do |callback_kind, callback_name, method_name|
  match do |model_class|
    model_class.__callbacks[callback_name].any? do |cb|
      cb.kind == callback_kind.to_sym && cb.filter == method_name.to_sym
    end
  end

  description do
    "have a #{callback_kind}_#{callback_name} callback defined for #{method_name}"
  end

  failure_message do |model_class|
    "expected to have a #{callback_kind}_#{callback_name} callback defined for #{method_name}"
  end

  failure_message_when_negated do |model_class|
    "expected not to have a #{callback_kind}_#{callback_name} callback defined for #{method_name}"
  end
end
