# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class AddEnumUnitOfMeasures < Medici::Database::Migration[1.0]
  def change
    create_enum :unit_of_measures,
                [
                  :kg,
                  :g,
                  :mg,
                  :mcg,
                  :l,
                  :ml,
                  :cc,
                  :mol,
                  :mmol,
                  :ww,
                  :qs,
                  :wv,
                  :lb,
                  :f,
                  :c,
                  :oz,
                  :tbsp,
                  :tsp,
                  :gtt,
                  :gr,
                  :gal,
                  :pt,
                  :m,
                  :qt,
                  :floz,
                  :fldr,
                  :dr,
                  :vv
                ]
  end
end
