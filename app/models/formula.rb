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

class Formula
  include Redmine::I18n

  def self.available_names
    ComputableCustomField::Configuration.formulas
  end

  def self.name_pattern
    available_names.join('|')
  end

  def initialize(expression:)
    @expression = expression
  end

  ##
  # @return [String] Name of the formula or empty String if nothing matches.
  #
  def name
    matched_data.to_s
  end

  ##
  # @return [String] Arguments of formula or empty String if there are no arguments.
  #
  def arguments
    matched_data.post_match.delete('()')
  end

  def validate(record)
    return if record.errors.any?

    return record.errors.add :base, l(:error_unknown_formula) unless name_available?
    return record.errors.add :base, l(:error_unsupported_formula) unless name_unsupported? record
  end

  private

  attr_reader :expression

  def matched_data
    expression&.match(self.class.name_pattern) || empty_data
  end

  def empty_data
    ' '.match(Regexp.new('\s'))
  end

  def name_available?
    self.class.available_names.include? name
  end

  def name_unsupported?(record)
    field_format(record).supported_math_functions.include? name
  end

  def field_format(record)
    "Redmine::FieldFormat::#{record.field_format.classify}Format".constantize
  end
end
