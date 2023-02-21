# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

<% module_namespacing do -%>
class <%= class_name %>Service < ApplicationService
  def initialize
  end

  def call
    <% if methods.any? %>
    <% for method in methods %>
    <%= method %>
    <% end %>
    <% end %>
  end

  <% if methods.any? %>
  <%= "private" %>
  <% for method in methods %>
  <%= "def #{method}" %>
  <%= "end" %>
  <% end %>
  <% end %>
end
<% end -%>
