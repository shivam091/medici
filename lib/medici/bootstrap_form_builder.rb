# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# NOTE: The rich_text_area and rich_text_area_tag helpers are defined in a file with a different
# name and not in the usual autoload-reachable way.
if ::Rails::VERSION::STRING > "6"
  require "#{Gem::Specification.find_by_name("actiontext").gem_dir}/app/helpers/action_text/tag_helper"
end
require "action_view"
require "action_pack"
require File.dirname(__FILE__) + "/bootstrap_form_builder/action_view_extensions/form_helper"
require File.dirname(__FILE__) + "/bootstrap_form_builder/helpers"

require File.dirname(__FILE__) + "/bootstrap_form_builder/configuration"
require File.dirname(__FILE__) + "/bootstrap_form_builder/form_builder"

module BootstrapFormBuilder
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end
  end

  mattr_accessor :field_error_proc
  @@field_error_proc = proc do |html_tag, instance|
    html_doc = Nokogiri::HTML::DocumentFragment.parse(html_tag, Encoding::UTF_8.to_s)
    element = html_doc.children[0]
    if element
      element.add_class("is-invalid")
      instance.raw(html_doc.to_html)
    else
      html_tag
    end
  end
end
