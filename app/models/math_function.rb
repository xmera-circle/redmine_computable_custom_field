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

class MathFunction
  def initialize(name:, fragments:, context:, custom_field:)
    @name = name
    @fragments = fragments
    @context = context
    @custom_field = custom_field
  end

  def calculate
    base_function.calculate
  end

  private

  attr_reader :name, :fragments, :context, :custom_field

  ##
  # The function determined by the formula name, e.g., SumFunction.
  #
  def base_function
    klass.new(fragments: fragments, custom_field: custom_field, context: context)
  end

  def klass
    name.present? ? "#{name.classify}Function".constantize : NullFunction
  end
end
