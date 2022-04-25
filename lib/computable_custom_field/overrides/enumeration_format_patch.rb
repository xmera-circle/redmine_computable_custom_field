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

module ComputableCustomField
  module EnumerationFormatPatch
    def self.prepended(base)
      base.prepend(InstanceMethods)
    end

    module InstanceMethods
      ##
      # @override Computable key/value fields are using the position number
      #   as computable entry. Therefore, they must be found by its position
      #   and custom field id.
      #
      def cast_single_value(custom_field, value, _customized = nil)
        return super unless custom_field.is_computed?

        return unless value.present?

        target_class
          .where(custom_field_id: custom_field.id)
          .where(position: value.to_i)
          .take
      end
    end
  end
end

Rails.configuration.to_prepare do
  patch = ComputableCustomField::EnumerationFormatPatch
  klass = Redmine::FieldFormat::EnumerationFormat
  klass.prepend patch unless klass.included_modules.include?(patch)
end
