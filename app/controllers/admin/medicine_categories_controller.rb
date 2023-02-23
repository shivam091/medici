# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

class Admin::MedicineCategoriesController < Admin::BaseController

# GET /admin/medicine-categories
def index
  @medicine_categories = ::MedicineCategory.active
  @pagy, @medicine_categories = pagy(@medicine_categories)
end
end
