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

class FormulaSyntaxCheck
  include Redmine::I18n

  def initialize(name:, fragments:)
    @name = name
    @fragments = fragments
  end

  def validate(record)
    return if record.errors.any?

    record.errors.add :base, l(:error_invalid_arguments) unless valid_syntax?
    record.errors.add :base, l(:error_too_many_fields) if too_many_fields?
  end

  private

  attr_reader :name, :fragments

  def valid_syntax?
    (operators & operator).present? || (delimiters & delimiter).present?
  end

  def too_many_fields?
    return if base_function.unlimited_fields?

    base_function.max_num_of_fields < fragments.ids.count
  end

  def operator
    fragments.operator
  end

  def operators
    base_function.available_operators
  end

  def delimiter
    fragments.delimiter
  end

  def delimiters
    base_function.available_delimiters
  end

  ##
  # The function determined by the formula name, e.g., SumFunction.
  #
  def base_function
    klass.new(fragments: fragments, custom_field: nil, context: nil)
  end

  def klass
    name.present? ? "#{name.classify}Function".constantize : NullFunction
  end
end
