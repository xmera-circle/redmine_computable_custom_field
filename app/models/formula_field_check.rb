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

class FormulaFieldCheck
  include Redmine::I18n

  def initialize(field_ids:)
    @field_ids = field_ids
  end

  def validate(record)
    record.errors.add :base, l(:error_invalid_field) unless available_fields?(record)
    results = custom_fields(record).map(&:valid_format_for_computation?)
    record.errors.add :base, l(:error_unsupported_field_format) unless results.all?
  end

  private

  attr_reader :field_ids

  def available_fields?(record)
    (field_ids - custom_fields(record).pluck(:id)).empty?
  end

  def custom_fields(record)
    record.class.where(id: field_ids)
  end
end
