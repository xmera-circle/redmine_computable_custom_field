# frozen_string_literal: true

#
# Redmine plugin for xmera called Computable Custom Field Plugin.
#
# Copyright (C) 2021 - 2022  Liane Hampe <liaham@xmera.de>, xmera.
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
  module CustomFieldsHelperPatch
    def computable?(custom_field)
      custom_field.valid_type_for_computation? &&
        custom_field.valid_format_for_computation? &&
        (custom_field.new_record? || custom_field.is_computed?)
    end

    def render_computable_custom_fields_select(custom_field)
      options = render_options_for_computable_custom_fields_select(custom_field)
      select_tag '', options, size: 5, multiple: true, id: 'available_cfs'
    end

    def render_options_for_computable_custom_fields_select(custom_field)
      options = custom_field.fields_for_select.map do |field|
        is_computed = field.is_computed? ? ", #{l(:field_is_computed)}" : ''
        format = I18n.t(field.format.label)
        title = "#{field.name} (#{format}#{is_computed}, #{field.id})"
        content_tag(:option, title, value: field.id, title: title)
      end
      return content_tag(:option, l(:label_no_data), value: ' ', title: l(:label_no_data)) if options.blank?

      options.join.html_safe
    end
  end
end

Rails.configuration.to_prepare do
  patch = ComputableCustomField::CustomFieldsHelperPatch
  klass = CustomFieldsHelper
  klass.include patch unless klass.included_modules.include?(patch)
end
