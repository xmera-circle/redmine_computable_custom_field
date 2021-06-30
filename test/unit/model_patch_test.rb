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

require File.expand_path('../test_helper', __dir__)

class ModelPatchTest < ComputableCustomFieldTestCase
  test 'patch inclusion' do
    models = [Enumeration, Group, Issue, Project, TimeEntry, User, Version]
    models.each do |model|
      assert model.included_modules.include?(ComputableCustomField::ModelPatch)
    end
  end

  test 'floath with division by zero' do
    field = field_with_float_format
    field.update(formula: 'custom(cfs[6]/cfs[1])')
    issue.save
    assert_equal 'Infinity', issue.custom_field_value(field.id)
  end

  test 'sum with int format' do
    field = field_with_int_format
    formula = 'sum(cfs[6],cfs[6],cfs[6])'
    result = (3 * issue.custom_field_value(6).to_f)
    field.update_attribute(:formula, formula)
    issue.save
    assert_equal result.to_s, issue.custom_field_value(field.id)
  end

  test 'sum with float format' do
    field = field_with_float_format
    formula = 'sum(cfs[6],cfs[6])'
    result = (2 * issue.custom_field_value(6).to_f)
    field.update_attribute(:formula, formula)
    issue.save
    assert_equal result.to_s, issue.custom_field_value(field.id)
  end
end
