# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class PresenterGenerator < Rails::Generators::NamedBase
  desc "This generator creates a presenter in app/presenters."

  argument :targets, type: :array, default: []

  check_class_collision suffix: "Presenter"
  source_root File.expand_path("../templates", __FILE__)

  def create_presenter_file
    template "presenter.rb", presenter_path
  end

  def create_presenter_test_file
    case Rails.application.config.generators.rails[:test_framework]
    when :rspec
      template "rspec.rb", rspec_path
    when :test_unit
      template "test_unit.rb", test_unit_path
    when :mini_test
      if Rails.application.config.generators.mini_test[:spec]
        template "mini_test_spec.rb", mini_test_path
      else
        template "mini_test_unit.rb", mini_test_path
      end
    end
  end

  private

  def target_list
    target_names.join(", ")
  end

  def target_names
    targets.map { |t| ":#{t}" }
  end

  def presenter_path
    File.join("app/presenters", class_path, "#{file_name}_presenter.rb")
  end

  def rspec_path
    File.join("spec/presenters", class_path, "#{file_name}_presenter_spec.rb")
  end

  def test_unit_path
    File.join("test/unit/presenters", class_path, "#{file_name}_presenter_test.rb")
  end

  def mini_test_path
    File.join("test/presenters", class_path, "#{file_name}_presenter_test.rb")
  end
end
