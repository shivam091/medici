# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class String
  # Method to truncate exact char length at specified by truncate_at.
  def truncate(truncate_at, options = {})
    return dup unless length > truncate_at

    omission = options[:omission] || "..."
    stop = rindex(omission, truncate_at) || truncate_at

    "#{self[0, stop]}#{omission}"
  end
end
