# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module TextHelper
  def word_wrap(text, options = {})
    options.reverse_merge!(line_width: 80, seperator: "<br/>")
    text = text.split(" ").collect do |word|
      if word.length > options[:line_width]
        word.gsub(/(.{1,#{options[:line_width]}})/, "\\1 ")
      else
        word
      end
    end * " "
    text.split("#{options[:seperator]}").collect do |line|
      if line.length > options[:line_width]
        line.gsub(/(.{1,#{options[:line_width]}})(\s+|$)/, "\\1#{options[:seperator]}").strip
      else
        line
      end
    end * "#{options[:seperator]}"
  end
end
