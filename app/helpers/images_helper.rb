# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# Helper methods for rendering images, SVGs.
#
module ImagesHelper
  def external_svg_tag(file_name, options = {})
    options.reverse_merge!(height: "20px", width: "20px")

    file = File.read(Rails.root.join("app", "assets", "images", file_name))
    doc = Nokogiri::HTML::DocumentFragment.parse(file)
    svg = doc.at_css("svg")

    options.each do |attr, value|
      if value.is_a?(Hash)
        value.each do |a, val|
          svg["#{attr.to_s}-#{a.to_s.dasherize}"] = val
        end
      else
        svg[attr.to_s] = value
      end
    end

    doc.to_html.html_safe
  end

  def inline_svg_tag(symbol_id, options = {})
    options.reverse_merge!(height: "20px", width: "20px", fill: "currentColor")
    svg_class = ["icon"]
    svg_class << ["icon-#{symbol_id}"]
    svg_class << [options.delete(:class)]
    icon_element = content_tag(:use, "", { "xlink:href" => "#{image_url("svgs/defs.svg")}#icon-" + symbol_id })
    content_tag(:svg, class: svg_class.compact.reject(&:blank?), **options) do
      concat(icon_element)
    end
  end
end
