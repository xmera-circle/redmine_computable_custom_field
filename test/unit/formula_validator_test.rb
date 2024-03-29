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

module ComputableCustomField
  class FormulaValidatorTest < ComputableCustomFieldTestCase
    # Custom Field formats:
    #  - id: 6 -> float field
    #  - id: 8 -> date field

    test 'should reject unknown formula' do
      field = field_validation(formula: 'cfs[6]+cfs[6]',
                               field_format: 'float')
      assert_not field.valid?
    end

    test 'should reject arbitrary text as formula' do
      field = field_validation(formula: 'arbitrary text',
                               field_format: 'float')
      assert_not field.valid?
    end

    test 'should confirm valid formulas' do
      %w[int float list enumeration].each do |format|
        %w[sum min max product division].each do |formula|
          field = field_validation(formula: "#{formula}(cfs[6],cfs[6],cfs[6])",
                                   field_format: format)
          assert field.valid?
        end
        field = field_validation(formula: 'custom(cfs[6]+cfs[6]-cfs[6])',
                                 field_format: format)
        assert field.valid?
      end
    end

    test 'should reject missing custom field ids' do
      field = field_validation(formula: 'max(cfs[],cfs[])',
                               field_format: 'float')
      assert_not field.valid?
    end

    test 'should reject unknown operators' do
      field = field_validation(formula: 'sum(cfs[6]~cfs[6])',
                               field_format: 'float')
      assert_not field.valid?
    end

    test 'should reject inapplicable custom_field ids' do
      field = field_validation(formula: 'custom(cfs[8]+cfs[8])',
                               field_format: 'float')
      assert_not field.valid?
    end

    test 'should reject custom_field_ids where multiple is true' do
      multiple_field = IssueCustomField.generate!(field_format: 'list',
                                                  possible_values: %w[1 2],
                                                  multiple: true)
      field = field_validation(formula: "custom(cfs[#{multiple_field.id}] * 2)",
                               field_format: 'float')
      assert_not field.valid?
    end

    private

    def field_validation(formula:, field_format:)
      public_send "field_with_#{field_format}_format", formula: formula
    end
  end
end
