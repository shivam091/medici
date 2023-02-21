# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module ApplicationHelper
  def render_if_exists(partial = nil, **options)
    return unless partial_exists?(partial || options[:partial])

    if partial.nil?
      render(**options)
    else
      render(partial, options)
    end
  end

  def partial_exists?(partial)
    lookup_context.exists?(partial, [], true)
  end

  def template_exists?(template)
    lookup_context.exists?(template, [], false)
  end

  def outdated_browser?
    browser.ie?
  end

  def asset_to_string(name)
    app = Rails.application
    if Rails.configuration.assets.compile
      app.assets.find_asset(name).to_s
    else
      controller.view_context.render(file: Rails.root.join("public/assets", app.assets_manifest.assets[name]).to_s)
    end
  end

  # Returns active css class when condition returns true
  # otherwise returns nil.
  #
  # Example:
  #   %li{ class: active_when(params[:filter] == '1') }
  def active_when(condition)
    "active" if condition
  end

  # While similarly named to Rails's `link_to_if`, this method behaves quite differently.
  # If `condition` is truthy, a link will be returned with the result of the block
  # as its body. If `condition` is falsy, only the result of the block will be returned.
  def conditional_link_to(condition, options, html_options = {}, &block)
    if condition
      link_to options, html_options, &block
    else
      capture(&block)
    end
  end

  def truncate_first_line(message, length = 50)
    truncate(message.each_line.first.chomp, length: length) if message
  end

  # Check if a particular controller is the current one
  #
  # args - One or more controller names to check (using path notation when inside namespaces)
  #
  # Examples
  #
  #   # On DoctorController
  #   current_controller?(:doctors)           # => true
  #   current_controller?(:patients)        # => false
  #
  #   # On Admin::ApplicationController
  #   current_controller?(:application)         # => true
  #   current_controller?("admin/application")  # => true
  def current_controller?(*args)
    args.any? do |v|
      Medici::Utils.safe_downcase!(v.to_s).in?([controller.controller_name, controller.controller_path])
    end
  end

  # Check if a particular action is the current one
  #
  # args - One or more action names to check
  #
  # Examples
  #
  #   # On Doctors#new
  #   current_action?(:new)           # => true
  #   current_action?(:create)        # => false
  #   current_action?(:new, :create)  # => true
  def current_action?(*args)
    args.any? { |v| Medici::Utils.safe_downcase!(v.to_s) == action_name }
  end

  def get_copyright_year
    copyright_start_year = 2023
    copyright_end_year = Date.current.year
    if copyright_start_year.eql?(copyright_end_year)
      copyright_end_year
    else
      "#{copyright_start_year} - #{copyright_end_year}"
    end
  end

  def button_text(key)
    t(key, scope: "button_texts")
  end

  def secret_reveal_button(for_devise_views: false)
    classes = for_devise_views ? "btn-secret-reveal" : "btn btn-secondary"

    button_tag type: :button, class: classes, data: {action: "click->secret-reveal#toggle"} do
      concat(external_svg_tag("svgs/eye-visible.svg", data: {secret_reveal_target: "icon"}))
      concat(external_svg_tag("svgs/eye-hidden.svg", class: "d-none", data: {secret_reveal_target: "icon"}))
    end
  end
end
