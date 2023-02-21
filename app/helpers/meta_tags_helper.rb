# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module MetaTagsHelper
  # <% title @post.title %>
  def title(*text)
    title_text = []
    title_text << [text]
    content_for :title, title_text.join(" &middot; ").html_safe
  end

  # <% meta_tag :description, @post.description %>
  # <% meta_tag :keywords, @post.keywords.join(',') %>
  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  # <meta name="description" content="<%= yield_meta_tag(:description, 'Default description') %>" />
  # <meta name="keywords" content="<%= yield_meta_tag(:keywords, 'defaults,ruby,rails') %>" />
  def yield_meta_tag(tag, default_text = "")
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
  end
end
