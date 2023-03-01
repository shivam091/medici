# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

# Asserts that the check constraint exists.
#
# ```
# RSpec.describe TableName, type: :model do
#   it { is_expected.to have_check_constraint("unique_constraint_name") }
#   it { is_expected.to have_check_constraint("unique_constraint_name").with_condition("name is not null") }
# end
# ```

RSpec::Matchers.define :have_check_constraint do |constraint_name|
  chain :with_condition do |condition|
    @condition = condition
  end

  match do |record|
    @table_name = record.class.table_name
    check_constraints = ActiveRecord::Base.connection.check_constraints(@table_name)

    if @condition
      check_constraints.any? do |check_constraint|
        check_constraint.name == constraint_name &&
          check_constraint.table_name == @table_name.to_s &&
          check_constraint.expression.eql?(@condition)
      end
    else
      check_constraints.any? do |check_constraint|
        check_constraint.name == constraint_name &&
          check_constraint.table_name == @table_name.to_s
      end
    end
  end

  description do
    "have a check constraint named '#{constraint_name}' on the table '#{@table_name}'"
  end

  failure_message do
    if @condition
      "expected '#{@table_name}' to have a check constraint named '#{constraint_name}' with condition '#{@condition}'"
    else
      "expected to have a check constraint named '#{constraint_name}'"
    end
  end

  failure_message_when_negated do
    if @condition
      "expected '#{@table_name}' to not have a check constraint named '#{constraint_name}' with condition '#{@condition}'"
    else
      "expected not to have a check constraint named '#{constraint_name}'"
    end
  end
end
