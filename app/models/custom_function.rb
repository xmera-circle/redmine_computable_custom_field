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

class CustomFunction < BaseFunction
  # The formula as provided by the user was fragmented in valid
  # components and recombined as sanitized formula before it is
  # evaluated below.
  def calculate
    eval(sanitized_formula) # rubocop:disable Security/Eval
  end

  def available_operators
    %w[+ - * /]
  end

  def available_delimiters
    []
  end

  def available_signs
    %w[+ -]
  end

  private

  def sanitized_formula
    values.zip(operators).flatten.compact.join(' ')
  end

  def operators
    fragments.operator
  end
end
