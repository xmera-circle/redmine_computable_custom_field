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

module MethodsHelper
  def issue
    Issue.find 3
  end

  def project
    Project.find 1
  end

  def field_with_string_format
    computed_field 'string'
  end

  def field_with_list_format
    computed_field 'list', possible_values: %w[1 2 3]
  end

  def field_with_float_format
    computed_field 'float'
  end

  def field_with_int_format
    computed_field 'int'
  end

  def computed_field(format, attributes = {})
    @generated_field_name ||= +"#{format.capitalize} Field 0"
    @generated_field_name.succ!
    params = attributes.merge(name: @generated_field_name, is_computed: true,
                              field_format: format, is_for_all: true)
    field = IssueCustomField.create params
    field.trackers << Tracker.first if field.is_a? IssueCustomField
    field
  end
end
