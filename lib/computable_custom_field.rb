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

# Extensions
require_relative 'computable_custom_field/extensions/custom_field_patch'
require_relative 'computable_custom_field/extensions/custom_fields_helper_patch'
require_relative 'computable_custom_field/extensions/model_patch'
require_relative 'computable_custom_field/extensions/field_format_patch'

# Hooks
require_relative 'computable_custom_field/hooks/view_hooks'

# Overrides
require_relative 'computable_custom_field/overrides/issue_patch'
require_relative 'computable_custom_field/overrides/enumeration_format_patch'

require_relative 'computable_custom_field/configuration'

module ComputableCustomField
  class << self
    def setup
      %w[custom_field_patch custom_fields_helper_patch field_format_patch
         enumeration_format_patch issue_patch].each do |patch|
        AdvancedPluginHelper::Patch.register(send(patch))
      end
      ComputableCustomField::Configuration.models.each do |klass|
        AdvancedPluginHelper::Patch.register(send(:model_patch, klass))
      end
      AdvancedPluginHelper::Patch.apply do
        { klass: ComputableCustomField::Configuration,
          method: :add_supported_formulas }
      end
    end

    private

    def custom_field_patch
      { klass: CustomField,
        patch: ComputableCustomField::Extensions::CustomFieldPatch,
        strategy: :include }
    end

    def custom_fields_helper_patch
      { klass: CustomFieldsHelper,
        patch: ComputableCustomField::Extensions::CustomFieldsHelperPatch,
        strategy: :prepend }
    end

    def field_format_patch
      { klass: Redmine::FieldFormat::Base,
        patch: ComputableCustomField::Extensions::FieldFormatPatch,
        strategy: :include }
    end

    def model_patch(klass)
      { klass: klass,
        patch: ComputableCustomField::Extensions::ModelPatch,
        strategy: :include }
    end

    def enumeration_format_patch
      { klass: Redmine::FieldFormat::EnumerationFormat,
        patch: ComputableCustomField::Overrides::EnumerationFormatPatch,
        strategy: :prepend }
    end

    def issue_patch
      { klass: Issue,
        patch: ComputableCustomField::Overrides::IssuePatch,
        strategy: :prepend }
    end
  end

  module Configuration
    self.models = %w[Issue]
    self.formats = %w[int float list enumeration]
    self.formulas = %w[sum min max product division custom]

    def self.add_supported_formulas
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
        next unless defined? base.supported_math_functions

        base.supported_math_functions = format.formulas
      end
    end
  end
end
