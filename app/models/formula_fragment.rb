# frozen_string_literal: true

#
# Redmine plugin for xmera called Computable Custom Field Plugin.
#
# Copyright (C) 2021 Liane Hampe <liaham@xmera.de>, xmera.
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

class FormulaFragment
  include Redmine::I18n

  attr_reader :arguments

  def initialize(arguments:)
    @arguments = arguments
  end

  def ids
    cf_ids = extracted_cfs.map do |item|
      item.scan(id_pattern)
    end
    cf_ids.flatten!
    cf_ids.map!(&:to_i)
  end

  def delimiter
    arguments.scan(del_pattern).flatten
  end

  def operator
    arguments.scan(op_pattern).flatten
  end

  def sign
    arguments.scan(sgn_pattern).flatten
  end

  def validate(record)
    return if record.errors.any?
    return record.errors.add :base, l(:error_missing_fields) if ids.blank?
    return if ids.count < 2

    record.errors.add :base, l(:error_missing_arguments) if operator.blank? && delimiter.blank?
  end

  private

  def extracted_cfs
    arguments.scan(cfs_pattern).flatten
  end

  def cfs_pattern
    Regexp.new('(cfs\[\d+\])')
  end

  def id_pattern
    Regexp.new('cfs\[(\d+)\]')
  end

  def op_pattern
    Regexp.new('(\+|\-|\/|\*)')
  end

  def del_pattern
    Regexp.new('(\,)')
  end

  def sgn_pattern
    Regexp.new('(\+|\-)cfs')
  end
end
