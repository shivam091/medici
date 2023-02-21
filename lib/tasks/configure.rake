# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# rake medici:configure RAILS_ENV=XXX
# rake medici:unconfigure! RAILS_ENV=XXX

require File.dirname(__FILE__) + "/rake_helper.rb"

namespace :medici do

  desc "Configure Medici on new system"
  task configure: :environment do
    answer = prompt("You are about to configure the Medici in #{Rails.env} " \
      "environment. Do you want to proceed? (Yn): ", %w{Y n})
    if answer == "Y"
      puts "↳ -------------------------------> Installing Medici"
      begin
        sh "bundle install"
        Rake::Task["tmp:create"].invoke
        Rake::Task["db:create"].invoke
        Rake::Task["db:migrate"].invoke
        Rake::Task["db:seed"].invoke
        Rake::Task["medici:db:seed"].invoke
        Rake::Task["assets:precompile"].invoke
        sh "rspec"
        puts "↳ ----------------------------> Installation Completed"
      rescue Exception => e
        raise "Installation aborted due to internal errors!"
      end
    else
      puts "Installation cancelled by the user."
    end
  end

  desc "Unconfigure Medici from the system"
  task unconfigure!: :environment do
    Kernel.warn ERB.new(<<~EOS).result
      ******************************************************************************
      ******************************************************************************
                ██     ██  █████  ██████  ███    ██ ██ ███    ██  ██████ 
                ██     ██ ██   ██ ██   ██ ████   ██ ██ ████   ██ ██      
                ██  █  ██ ███████ ██████  ██ ██  ██ ██ ██ ██  ██ ██   ███ 
                ██ ███ ██ ██   ██ ██   ██ ██  ██ ██ ██ ██  ██ ██ ██    ██ 
                 ███ ███  ██   ██ ██   ██ ██   ████ ██ ██   ████  ██████  
      ******************************************************************************
      ******************************************************************************
    EOS
    answer = prompt("You are about to unconfigure the Medici in " \
      "#{Rails.env} environment. This action can not be UNDONE. Do you still " \
      "want to proceed? (Yn): ", %w{Y n})
    if answer == "Y"
      puts "↳ -----------------------------> Uninstalling Medici"
      begin
        Rake::Task["assets:clobber"].invoke
        Rake::Task["db:drop"].invoke
        Rake::Task["log:clear"].invoke
        Rake::Task["tmp:clear"].invoke
        puts "↳ --------------------------> Uninstallation Completed"
      rescue Exception => e
        raise "Uninstallation aborted due to internal errors!"
      end
    else
      puts "Uninstallation cancelled by the user."
    end
  end
end
