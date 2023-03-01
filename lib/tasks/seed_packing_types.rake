# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:db:seed_packing_types RAILS_ENV=XXX

namespace :medici do
  namespace :db do
    desc "Seeds packing types"
    task seed_packing_types: :environment do
      CSV.foreach("#{Rails.root}/db/data/packing_types.csv", headers: true) do |row|
        begin
          ::PackingType.unscope(where: :is_active).safe_find_or_create_by(name: row["name"]) do |packing_type|
            packing_type.is_active = true
            puts "PackingType --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "PackingType --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
