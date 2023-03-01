# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:db:seed_ingredients RAILS_ENV=XXX

namespace :medici do
  namespace :db do
    desc "Seeds ingredients"
    task seed_ingredients: :environment do
      CSV.foreach("#{Rails.root}/db/data/ingredients.csv", headers: true) do |row|
        begin
          ::Ingredient.unscope(where: :is_active).safe_find_or_create_by(name: row["name"]) do |ingredient|
            ingredient.is_active = true
            puts "Ingredient --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "Ingredient --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
