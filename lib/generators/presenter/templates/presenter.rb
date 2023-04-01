# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

<% module_namespacing do -%>
class <%= class_name %>Presenter < BasePresenter
<% if targets.any? -%>
  presents <%= target_list %>
<% end -%>
end
<% end -%>
