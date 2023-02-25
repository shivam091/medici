# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:db:seed_dosage_forms RAILS_ENV=XXX

namespace :medici do
  namespace :db do
    desc "Seeds dosage forms"
    task seed_dosage_forms: :environment do
      CSV.foreach("#{Rails.root}/db/data/dosage_forms.csv", headers: true) do |row|
        begin
          ::DosageForm.unscope(where: :is_active).safe_find_or_create_by(name: row["name"]) do |dosage_form|
            dosage_form.is_active = true
            puts "DosageForm --> [#{row["name"]}] is added successfully."
          end
        rescue Exception => e
          raise "DosageForm --> [#{row["name"]}] is aborted due to internal errors!"
        end
      end
    end
  end
end
