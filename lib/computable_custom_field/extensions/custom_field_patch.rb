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
  module CustomFieldPatch
    def self.included(base)
      base.class_eval do
        base.before_validation -> { self.formula ||= '' }, if: :is_computed?
        base.validates_with ::FormulaValidator, if: :is_computed?
        base.safe_attributes 'is_computed', 'formula' if CustomField.respond_to? 'safe_attributes'
        base.scope :computable, -> { where(is_computed: false).where(field_format: ComputableCustomField::FORMATS) }
        base.scope :computable_group_by_id, -> { computable.group_by.map(&:id) }
        base.scope :computed, -> { where(is_computed: true) }
      end
    end

    def is_computed=(arg)
      # cannot change is_computed of a saved custom field
      super if new_record?
    end

    def valid_type_for_computation?
      type_from_class_name.present?
    end

    def valid_format_for_computation?
      format_in?(*ComputableCustomField::FORMATS)
    end

    def fields_for_select
      self.class.computable
    end

    private

    def type_from_class_name
      self.class.name.scan(Regexp.new(ComputableCustomField::MODELS.join('|')))
    end
  end
end

Rails.configuration.to_prepare do
  patch = ComputableCustomField::CustomFieldPatch
  klass = CustomField
  klass.include patch unless klass.included_modules.include?(patch)
end
