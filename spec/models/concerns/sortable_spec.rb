# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# spec/models/concerns/sortable_spec.rb

require "spec_helper"

RSpec.describe Sortable do
  describe "scopes" do
    describe "secondary ordering by id" do
      let(:sorted_relation) { ::DosageForm.all.order_created_asc }

      def arel_orders(relation)
        relation.arel.orders
      end

      it "allows secondary ordering by id ascending" do
        orders = arel_orders(sorted_relation.with_order_id_asc)

        expect(orders.map { |arel| arel.expr.name }).to eq(%w(created_at id))
        expect(orders).to all(be_kind_of(Arel::Nodes::Ascending))
      end

      it "allows secondary ordering by id descending" do
        orders = arel_orders(sorted_relation.with_order_id_desc)

        expect(orders.map { |arel| arel.expr.name }).to eq(%w(created_at id))
        expect(orders.first).to be_kind_of(Arel::Nodes::Ascending)
        expect(orders.last).to be_kind_of(Arel::Nodes::Descending)
      end
    end
  end

  describe ".order_by" do
    let(:arel_table) { ::DosageForm.arel_table }
    let(:relation) { ::DosageForm.all }

    describe "ordering by id" do
      it "ascending" do
        expect(relation).to receive(:reorder).with(arel_table[:id].asc)

        relation.order_by(:id_asc)
      end

      it "descending" do
        expect(relation).to receive(:reorder).with(arel_table[:id].desc)

        relation.order_by(:id_desc)
      end
    end

    describe "ordering by created_at" do
      it "ascending" do
        expect(relation).to receive(:reorder).with(arel_table[:created_at].asc)

        relation.order_by(:created_asc)
      end

      it "descending" do
        expect(relation).to receive(:reorder).with(arel_table[:created_at].desc)

        relation.order_by(:created_desc)
      end

      it "order by 'created_at'" do
        expect(relation).to receive(:reorder).with(arel_table[:created_at].desc)

        relation.order_by(:created_date)
      end
    end

    describe "ordering by name" do
      it "ascending" do
        expect(relation).to receive(:reorder).once.and_call_original

        table = Regexp.escape(ApplicationRecord.connection.quote_table_name(:dosage_forms))
        column = Regexp.escape(ApplicationRecord.connection.quote_column_name(:name))

        sql = relation.order_by(:name_asc).to_sql

        expect(sql).to match(/.+ORDER BY LOWER\(#{table}.#{column}\) ASC\z/)
      end

      it "descending" do
        expect(relation).to receive(:reorder).once.and_call_original

        table = Regexp.escape(ApplicationRecord.connection.quote_table_name(:dosage_forms))
        column = Regexp.escape(ApplicationRecord.connection.quote_column_name(:name))

        sql = relation.order_by(:name_desc).to_sql

        expect(sql).to match(/.+ORDER BY LOWER\(#{table}.#{column}\) DESC\z/)
      end
    end

    describe "ordering by updated_at" do
      it "ascending" do
        expect(relation).to receive(:reorder).with(arel_table[:updated_at].asc)

        relation.order_by(:updated_asc)
      end

      it "descending" do
        expect(relation).to receive(:reorder).with(arel_table[:updated_at].desc)

        relation.order_by(:updated_desc)
      end

      it "order by 'updated_at'" do
        expect(relation).to receive(:reorder).with(arel_table[:updated_at].desc)

        relation.order_by(:updated_date)
      end
    end

    it "does not call reorder in case of unrecognized ordering" do
      expect(relation).not_to receive(:reorder)

      relation.order_by("random_ordering")
    end
  end

  describe "sorting groups" do
    def ordered_group_names(order)
      ::DosageForm.all.order_by(order).map(&:name)
    end

    let!(:ref_time) { Time.zone.parse("2018-05-01 00:00:00") }
    let!(:dosage_form1) do
      create(:dosage_form, name: "aa", id: "a68dc8d8-139e-4cbb-9016-35a609c478ff", created_at: (ref_time - 15.seconds), updated_at: ref_time)
    end
    let!(:dosage_form2) do
      create(:dosage_form, name: "AAA", id: "079cb484-8416-43e5-8498-f5a2b12277e0", created_at: (ref_time - 10.seconds), updated_at: (ref_time - 5.seconds))
    end
    let!(:dosage_form3) do
      create(:dosage_form, name: "BB", id: "cafc6951-8e76-4175-9009-53b695c64a7f", created_at: (ref_time - 5.seconds), updated_at: (ref_time - 10.seconds))
    end
    let!(:dosage_form4) do
      create(:dosage_form, name: "bbb", id: "882eb57f-29ea-4366-9403-a7384fad60b8", created_at: ref_time, updated_at: (ref_time - 15.seconds))
    end

    it "sorts dosage forms by id" do
      expect(ordered_group_names(:id_asc)).to eq(%w(AAA bbb aa BB))
      expect(ordered_group_names(:id_desc)).to eq(%w(BB aa bbb AAA))
    end

    it "sorts dosage forms by name via case-insensitive comparision" do
      expect(ordered_group_names(:name_asc)).to eq(%w(aa AAA BB bbb))
      expect(ordered_group_names(:name_desc)).to eq(%w(bbb BB AAA aa))
    end

    it "sorts dosage forms by created_at" do
      expect(ordered_group_names(:created_asc)).to eq(%w(aa AAA BB bbb))
      expect(ordered_group_names(:created_desc)).to eq(%w(bbb BB AAA aa))
      expect(ordered_group_names(:created_at_asc)).to eq(%w(aa AAA BB bbb))
      expect(ordered_group_names(:created_at_desc)).to eq(%w(bbb BB AAA aa))
      expect(ordered_group_names(:created_date)).to eq(%w(bbb BB AAA aa))
    end

    it "sorts dosage forms by updated_at" do
      expect(ordered_group_names(:updated_asc)).to eq(%w(bbb BB AAA aa))
      expect(ordered_group_names(:updated_desc)).to eq(%w(aa AAA BB bbb))
      expect(ordered_group_names(:updated_at_asc)).to eq(%w(bbb BB AAA aa))
      expect(ordered_group_names(:updated_at_desc)).to eq(%w(aa AAA BB bbb))
      expect(ordered_group_names(:updated_date)).to eq(%w(aa AAA BB bbb))
    end
  end
end
