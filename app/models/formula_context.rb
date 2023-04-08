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

class FormulaContext
  def initialize(field_ids:, grouped_fields:, available_fields:)
    @field_ids = field_ids
    @grouped_fields = grouped_fields
    @available_fields = available_fields # unused so far
  end

  ##
  # Uses the field_ids extracted from the formula and assigns the corresponding
  # value to each id. If there is no value, the required field_id is not
  # available for computation.
  #
  def cfs
    field_ids.each_with_object({}) do |field_id, hash|
      cfv = grouped_cf[field_id]&.first
      value = assign_value(cfv)
      hash[field_id] = value
    end
  end

  def assign_value(cfv)
    return unless valid? cfv

    cast_value(cfv)
  end

  ##
  # Check whether the format of a given custom field is computable.
  #
  def valid?(cfv)
    cf = cfv&.custom_field
    return false unless cf

    cf.valid_format_for_computation?
  end

  private

  attr_reader :field_ids, :grouped_fields, :available_fields

  ##
  # Available fields grouped by id.
  # Available fields can be either of class CustomField
  # or an array of class CustomFieldValues.
  #
  def grouped_cf
    grouped_fields
  end

  ##
  # If key/value field, the command CustomField#cast_value returns for instance
  # #<CustomFieldEnumeration id: 1, custom_field_id: 1, name: "B 1.1 ISMS", active: true, position: 1>
  # If so, the computable value is the position instead of the custom_field_id since
  # it is easier for the user to derive the value from a key/value custom field by
  # counting its position.
  #
  # @note: Could also be implemented in CustomField class.
  #
  def cast_value(cfv)
    value(cfv).is_a?(CustomFieldEnumeration) ? value(cfv).position : value(cfv)
  end

  def value(cfv)
    cfv.custom_field.cast_value(cfv.value)
  end
end
