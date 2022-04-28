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

class BaseFunction
  def initialize(fragments:, custom_field:, context: nil)
    @fragments = fragments
    @custom_field = custom_field
    @context = context
  end

  def calculate
    raise NotImplementedError, "#{__method__} needs to be implemented"
  end

  def available_operators
    []
  end

  def available_delimiters
    []
  end

  def available_signs
    []
  end

  ##
  # Returning -1 means no restrictions.
  #
  def max_num_of_fields
    -1
  end

  def unlimited_fields?
    max_num_of_fields == -1
  end

  private

  attr_reader :fragments, :custom_field, :context

  ##
  # Reads the custom field values as long as it is a single value.
  # Multiple values would occour if the underlying custom field has set
  # the attribute multiple to true. If so, the calculation would return no
  # result.
  #
  def values
    cfs = context.cfs
    out = field_ids.map { |id| cfs[id].to_f unless cfs[id].is_a? Array }
    out.compact
  end

  def field_ids
    fragments.ids
  end
end
