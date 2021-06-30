# frozen_string_literal: true

#
# Redmine plugin for xmera called Computable Custom Field Plugin.
#
# Copyright (C) 2021 Liane Hampe <liaham@xmera.de>, xmera.
# Copyright (C) 2015 - 2021 Yakov Annikov
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

module ComputableCustomField
  module ModelPatch
    extend ActiveSupport::Concern

    included do
      before_validation :calculate_computable_fields
    end

    private

    def calculate_computable_fields
      custom_field_values.each do |obj|
        next unless obj.custom_field.is_computed?

        calculate_computable_field obj.custom_field
      end
    end

    ##
    # Calculate each computable field and assign its prepared value to make
    # it accessable within the records custom field values.
    #
    def calculate_computable_field(custom_field)
      value = calculator(custom_field.formula).calculate
      self.custom_field_values = {
        custom_field.id => value
      }
    end

    ##
    # Instantiate a CustomFieldCalculator.
    #
    def calculator(formula)
      CustomFieldCalculator.new(formula: formula,
                                fields: custom_field_values,
                                grouped_fields: grouped_fields)
    end

    ##
    # Group custom field values by their custom field id.
    #
    # @return [Hash(key, Array(CustomFieldValue))]
    #
    def grouped_fields
      custom_field_values.group_by { |cfv| cfv.custom_field.id }
    end
  end
end
