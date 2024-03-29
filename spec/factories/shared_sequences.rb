# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

FactoryBot.define do
  sequence :phone_number,
           aliases: [
             :mobile_number,
             :fax_number,
             :registration_number
           ] do |n|
    n.to_s.rjust(10, "0")
  end

  sequence(:email) { |n| "email#{n}@medici.com" }
end
