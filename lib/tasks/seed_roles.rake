# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:db:seed_roles RAILS_ENV=XXX

desc "Seeds roles"
namespace :medici do
  namespace :db do
    task seed_roles: :environment do
      CSV.foreach("#{Rails.root}/db/data/roles.csv", headers: true) do |row|
        begin
          ::Role.unscope(where: :is_active).safe_find_or_create_by(name: row["name"]) do |role|
            role.is_active = true
            puts "Role --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          puts "Role --> [#{row["name"]}] is aborted due to internal errors."
        end
      end
    end
  end
end
