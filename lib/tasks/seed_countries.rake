# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:db:seed_countries RAILS_ENV=XXX

namespace :medici do
  namespace :db do
    desc "Seeds countries"
    task seed_countries: :environment do
      CSV.foreach("#{Rails.root}/db/data/countries.csv", headers: true) do |row|
        begin
          currency = ::Currency.find_sole_by(iso_code: row["currency_code"])
          currency.countries.unscope(where: :is_active).safe_find_or_create_by(iso2: row["iso2"]) do |country|
            country.name = row["name"]
            country.iso3 = row["iso3"]
            country.calling_code = (row["calling_code"].starts_with?("+") ? row["calling_code"] : "+#{row["calling_code"]}")
            country.has_postal_code = row["has_postal_code"]
            country.is_active = true
            puts "Country --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "Country --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
