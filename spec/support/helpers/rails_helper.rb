# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module RailsHelpers
  def stub_rails_env(env_name)
    allow(Rails).to receive(:env).and_return(ActiveSupport::StringInquirer.new(env_name))
  end
end
