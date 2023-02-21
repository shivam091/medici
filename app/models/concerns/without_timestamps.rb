# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# == Without Timestamps Module
#
# Mixin module to temporarily turn off time-stamping in a block:
#
# Usage:
#
#     class MyModel < ActiveRecord::Base
#       include WithoutTimestamps
#
#       def save_without_timestamps
#         without_timestamps do
#           save!
#         end
#       end
#     end
#
# or simply use like:
#
#     m = MyModel.find(1)
#     WithoutTimestamps.without_timestamps do
#       m.save!
#     end
#
module WithoutTimestamps
  extend ActiveSupport::Concern

  def self.included(base_class)
    def without_timestamps
      old = ActiveRecord::Base.record_timestamps
      ActiveRecord::Base.record_timestamps = false
      begin
        yield if block_given?
      rescue Exception => e
        Rails.logger.error(([e.message] + e.backtrace[0..3]).join($/))
      ensure
        ActiveRecord::Base.record_timestamps = old
      end
    end
  end
end
