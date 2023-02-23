# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class ApplicationService
  class << self
    def call(*args, &block)
      new(*args, &block).call
    end
  end

  def t(key, options = {})
    options.reverse_merge!(scope: "flash_messages")
    I18n.t(key, **options)
  end
end
