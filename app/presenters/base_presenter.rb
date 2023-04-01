# -*- encoding: utf-8 -*-
# -*- frozen_string_literal: true -*-
# -*- warn_indent: true -*-

##
# Main objective of presenters is to put logic out of the view.
# https://gist.github.com/joshuajhun/c69fdb5d46b7cd58448af4dcd6d776f5
#
class BasePresenter < SimpleDelegator
  def initialize(model, view)
    @model, @view = model, view
    super(@model)
  end

  def view_context
    @view
  end

  private

  def self.presents(name)
    define_method(name) do
      @model
    end
  end
end
