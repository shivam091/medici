# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:db:seed RAILS_ENV=XXX

require "csv"

namespace :medici do
  namespace :db do
    desc "Seeds the database with default data"
    task seed: :environment do
      begin
        Rake::Task["medici:db:seed_roles"].invoke
        Rake::Task["medici:db:seed_currencies"].invoke
        Rake::Task["medici:db:seed_countries"].invoke
        Rake::Task["medici:db:seed_medicine_categories"].invoke
        Rake::Task["medici:db:seed_dosage_forms"].invoke
        Rake::Task["medici:db:seed_packing_types"].invoke
        Rake::Task["medici:db:seed_ingredients"].invoke
      rescue Exception => e
        raise "Database population is aborted due to internal errors!"
      end
    end
  end
end
