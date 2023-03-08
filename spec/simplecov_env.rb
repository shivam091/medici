# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

require "simplecov"

module SimpleCovEnv
  extend self

  def start!
    configure_profile

    SimpleCov.start
  end

  def configure_profile
    SimpleCov.configure do
      # load_profile "test_frameworks"
      # track_files "{app,config/initializers,db/migrate,lib}/**/*.rb"

      # add_filter "/spec"

      add_group "Channels", "app/channels"
      add_group "Controllers", "app/controllers"
      add_group "Helpers", "app/helpers"
      add_group "Mailers", "app/mailers"
      add_group "Models", "app/models"
      add_group "Policies", "app/policies"
      add_group "Presenters", "app/presenters"
      add_group "Services", "app/services"
      add_group "Validators", "app/validators"
      add_group "Workers", %w[app/jobs app/workers]
      add_group "Initializers", "config/initializers"
      add_group "Migrations", "db/migrate"
      add_group "Libraries", "/lib"

      add_group "Long files" do |src_file|
        src_file.lines.count > 100
      end
      add_group "Short files" do |src_file|
        src_file.lines.count < 5
      end
    end
  end
end
