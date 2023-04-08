# frozen_string_literal: true

#
# Redmine plugin for xmera called Computable Custom Field Plugin.
#
# Copyright (C) 2021-2023  Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
# Copyright (C) 2015-2021 Yakov Annikov
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

module MethodsHelper
  def issue
    Issue.find 3
  end

  def project
    Project.find 1
  end

  def field_with_string_format(formula:)
    computed_field 'string', attributes: { formula: formula }
  end

  def field_with_list_format(formula:)
    computed_field 'list', attributes: { formula: formula,
                                         possible_values: %w[1 2 3] }
  end

  def field_with_float_format(formula:)
    computed_field 'float', attributes: { formula: formula }
  end

  def field_with_int_format(formula:)
    computed_field 'int', attributes: { formula: formula }
  end

  def field_with_enumeration_format(formula:)
    computed_field_enumeration(
      is_computed: true,
      attributes: {
        formula: formula,
        enumerations: {
          '1': { name: 'result1' },
          '2': { name: 'result2' },
          '3': { name: 'result3' },
          '4': { name: 'result4' },
          '5': { name: 'result5' },
          '6': { name: 'result6' },
          '7': { name: 'result7' },
          '8': { name: 'result8' },
          '9': { name: 'result9' }
        }
      }
    )
  end

  def computed_field(format, is_computed: true, attributes: {})
    @generated_field_name ||= + 'CF 0'
    @generated_field_name.succ!
    name = @generated_field_name + ", #{format}"
    enumerations = attributes.delete(:enumerations)
    params = attributes.merge(name: name, is_computed: is_computed,
                              field_format: format, is_for_all: true)
    field = IssueCustomField.create params
    field.trackers << Tracker.first if field.is_a? IssueCustomField
    field.save
    add_enumerations(field, enumerations)
    field.save
    field
  end

  ##
  # @param attributes [Hash] { enumerations: {'1': { name: 'enumeration1' },
  #                                           '2': { name: 'enumeration2' } }}
  #
  def computed_field_enumeration(is_computed: true, attributes: {})
    field = computed_field 'enumeration', is_computed: is_computed, attributes: attributes
    field.save
    field
  end

  def add_enumerations(field, enumerations)
    return unless enumerations

    enumerations.each do |key, values|
      field.enumerations.build(values.merge(position: key.to_s,
                                            custom_field_id: field.id))
    end
  end
end
