# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class AuditTrail < ApplicationRecord
  belongs_to :user
  belongs_to :auditable, polymorphic: true
  belongs_to :associated, polymorphic: true, optional: true
end
