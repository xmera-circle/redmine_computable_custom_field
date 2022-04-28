# frozen_string_literal: true

#
# Redmine plugin for xmera called Computable Custom Field Plugin.
#
# Copyright (C) 2021 - 2022  Liane Hampe <liaham@xmera.de>, xmera.
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

# Extensions
require 'computable_custom_field/extensions/custom_field_patch'
require 'computable_custom_field/extensions/custom_fields_helper_patch'
require 'computable_custom_field/extensions/model_patch'
require 'computable_custom_field/extensions/field_format_patch'
#require 'computable_custom_field/extensions/formula_support_patch'

# Hooks
require 'computable_custom_field/hooks/hooks'

# Overrides
require 'computable_custom_field/overrides/issue_patch'
require 'computable_custom_field/overrides/enumeration_format_patch'

require 'computable_custom_field/configuration'

module ComputableCustomField
  module Configuration
    self.models = %w[Issue]
    self.formats = %w[int float list enumeration]
    self.formulas = %w[sum min max product division custom]
  end
end

Rails.configuration.to_prepare do
  default_formulas = %w[sum min max product division custom]
  supported = []
  supported << ComputableCustomField::Configuration::Support.new(
    format: 'int',
    formulas: default_formulas
  )
  supported << ComputableCustomField::Configuration::Support.new(
    format: 'float',
    formulas: default_formulas
  )
  supported << ComputableCustomField::Configuration::Support.new(
    format: 'list',
    formulas: default_formulas
  )
  supported << ComputableCustomField::Configuration::Support.new(
    format: 'enumeration',
    formulas: default_formulas
  )

  supported.map do |format|
    base = format.klass
    base.supported_math_functions = format.formulas
  end
end
