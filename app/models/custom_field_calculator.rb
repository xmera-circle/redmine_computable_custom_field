# frozen_string_literal: true

#
# Redmine plugin for xmera called Computable Custom Field Plugin.
#
# Copyright (C) 2021-2023  Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

class CustomFieldCalculator
  def initialize(custom_field:, fields:, grouped_fields:)
    @custom_field = custom_field
    @formula = Formula.new(expression: custom_field.formula)
    @fields = fields
    @grouped_fields = grouped_fields
    @fragments = FormulaFragment.new(arguments: formula.arguments)
    @context = FormulaContext.new(field_ids: fragments.ids,
                                  grouped_fields: grouped_fields,
                                  available_fields: fields)
  end

  def calculate
    MathFunction.new(name: formula.name,
                     fragments: fragments,
                     context: context,
                     custom_field: custom_field).calculate
  end

  private

  attr_reader :custom_field, :formula, :fields, :grouped_fields, :fragments, :context
end
