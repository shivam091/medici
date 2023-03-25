# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

module DbCleaner
  def delete_from_all_tables!(except: [])
    except << "ar_internal_metadata"

    DatabaseCleaner.clean_with(:deletion, cache_tables: false, except: except)
  end
end
