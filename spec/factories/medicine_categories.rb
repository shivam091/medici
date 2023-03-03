# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :medicine_category do
    name { "Antihistamines" }
    description { "Drugs used primarily to counteract the effects of histamine, one of the chemicals involved in allergic reactions." }
  end
end
