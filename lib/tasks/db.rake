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
      rescue Exception => e
        raise "Database population is aborted due to internal errors!"
      end
    end
  end
end
