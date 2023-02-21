# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# == Sortable concern
#
# Mixin module containing set of shareable scopes and methods for ordering objects
#
module Sortable
  extend ActiveSupport::Concern

  def self.included(base_class)
    base_class.instance_eval do
      scope :with_order_id_desc, -> { order(arel_table[:id].desc) }
      scope :with_order_id_asc, -> { order(arel_table[:id].asc) }
      scope :order_id_desc, -> { reorder(arel_table[:id].desc) }
      scope :order_id_asc, -> { reorder(arel_table[:id].asc) }
      scope :order_created_desc, -> { reorder(arel_table[:created_at].desc) }
      scope :order_created_asc, -> { reorder(arel_table[:created_at].asc) }
      scope :order_updated_desc, -> { reorder(arel_table[:updated_at].desc) }
      scope :order_updated_asc, -> { reorder(arel_table[:updated_at].asc) }
      scope :order_name_asc, -> { reorder(Arel::Nodes::Ascending.new(arel_table[:name].lower)) }
      scope :order_name_desc, -> { reorder(Arel::Nodes::Descending.new(arel_table[:name].lower)) }
    end
  end

  class_methods do
    def order_by(method)
      simple_sorts.fetch(method, -> { all }).call
    end

    private

    def simple_sorts
      {
        created_asc: -> { order_created_asc },
        created_at_asc: -> { order_created_asc },
        created_date: -> { order_created_desc },
        created_desc: -> { order_created_desc },
        created_at_desc: -> { order_created_desc },
        id_asc: -> { order_id_asc },
        id_desc: -> { order_id_desc },
        name_asc: -> { order_name_asc },
        name_desc: -> { order_name_desc },
        updated_asc: -> { order_updated_asc },
        updated_at_asc: -> { order_updated_asc },
        updated_date: -> { order_updated_desc },
        updated_desc: -> { order_updated_desc },
        updated_at_desc: -> { order_updated_desc }
      }
    end
  end
end
