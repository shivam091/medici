# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:db:seed_medicine_categories RAILS_ENV=XXX

namespace :medici do
  namespace :db do
    desc "Seeds medicine categories"
    task seed_medicine_categories: :environment do
      CSV.foreach("#{Rails.root}/db/data/medicine_categories.csv", headers: true) do |row|
        begin
          ::MedicineCategory.unscope(where: :is_active).safe_find_or_create_by(name: row["name"]) do |medicine_category|
            medicine_category.description = row["description"]
            medicine_category.is_active = true
            puts "MedicineCategory --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "MedicineCategory --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
