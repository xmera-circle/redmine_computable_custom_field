# frozen_string_literal: true

#
# Redmine plugin for xmera called Computable Custom Field Plugin.
#
# Copyright (C) 2021-2023  Liane Hampe <liaham@xmera.de>, xmera Solutions GmbH.
# Copyright (C) 2015-2021 Yakov Annikov
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
    models = ComputableCustomField::Configuration.models
    assert_equal 1, models.size
    models.each do |model|
      assert model.included_modules.include?(ComputableCustomField::Extensions::ModelPatch)
    end
  end

  test 'float with division by zero' do
    field = field_with_float_format(formula: 'custom(cfs[6]/cfs[1])')
    issue.save
    assert_equal 'Infinity', issue.custom_field_value(field.id)
  end

  test 'sum with int format' do
    formula = 'sum(cfs[6],cfs[6],cfs[6])'
    field = field_with_int_format(formula: formula)
    result = (3 * issue.custom_field_value(6).to_f)
    field.update_attribute(:formula, formula)
    issue.save
    assert_equal result.to_s, issue.custom_field_value(field.id)
  end

  test 'sum with float format' do
    formula = 'sum(cfs[6],cfs[6])'
    field = field_with_float_format(formula: formula) 
    result = (2 * issue.custom_field_value(6).to_f)
    field.update_attribute(:formula, formula)
    issue.save
    assert_equal result.to_s, issue.custom_field_value(field.id)
  end

  test 'product with enumeration format' do
    first_value_field = custom_field_enumeration
    first_ids = first_value_field.enumerations.map(&:id)
    first_value = CustomValue.create!(custom_field: first_value_field,
                                      value: first_ids[1],
                                      customized: issue,
                                      customized_type: Issue)
    first_value.save
    second_value_field = custom_field_enumeration
    second_ids = second_value_field.enumerations.map(&:id)
    second_value = CustomValue.create!(custom_field: second_value_field,
                                       value: second_ids[2],
                                       customized: issue,
                                       customized_type: Issue)
    second_value.save
    assert issue.save_custom_field_values
    formula = "product(cfs[#{first_value_field.id}], cfs[#{second_value_field.id}])"
    result_field = field_with_enumeration_format(formula: formula)
    # first_value * second_value <=> 2 * 3 <=> 6
    result = ((first_ids.index(first_ids[1]) + 1) * (second_ids.index(second_ids[2]) + 1)).to_f
    assert_equal 6.0.to_s, result.to_s
    result_field.update_attribute(:formula, formula)
    assert issue.save
    assert_equal result.to_s, issue.custom_field_value(result_field.id)
  end

  private

  def custom_field_enumeration
    computed_field_enumeration(
      is_computed: false,
      attributes: {
        enumerations: {
          '1': { name: 'value1' },
          '2': { name: 'value2' },
          '3': { name: 'value3' }
        }
      }
    )
  end
end
