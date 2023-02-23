# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:db:seed_currencies RAILS_ENV=XXX

namespace :medici do
  namespace :db do
    desc "Seeds currencies"
    task seed_currencies: :environment do
      CSV.foreach("#{Rails.root}/db/data/currencies.csv", headers: true) do |row|
        begin
          ::Currency.unscope(where: :is_active).safe_find_or_create_by(iso_code: row["iso_code"]) do |currency|
            currency.name = row["name"]
            currency.symbol = row["symbol"]
            currency.subunit = row["subunit"]
            currency.subunit_to_unit = row["subunit_to_unit"]
            currency.symbol_first = row["symbol_first"]
            currency.thousands_separator = row["thousands_separator"]
            currency.decimal_mark = row["decimal_mark"]
            currency.is_active = true
            puts "Currency --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "Currency --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
