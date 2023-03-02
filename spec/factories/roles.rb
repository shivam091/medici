# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  factory :role do
    factory :admin_role, parent: :role do
      name { "admin" }
    end

    factory :cashier_role, parent: :role do
      name { "cashier" }
    end

    factory :manager_role, parent: :role do
      name { "manager" }
    end
  end
end
