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

class ComputableCustomFieldTest < ApplicationSystemTestCase
  include Redmine::I18n
  fixtures FixturesHelper.fixtures

  def setup
    super
    Capybara.current_session.reset!
    log_user 'admin', 'admin'
  end

  def test_new_custom_field_page_should_have_additional_fields
    visit new_custom_field_path type: 'IssueCustomField'
    within('#custom_field_form') do
      select 'Float', from: 'Format'
      page.fill_in('Name', with: 'Computed')
    end
    assert page.has_css?('input#custom_field_is_computed')
    assert page.has_css?('textarea#custom_field_formula')
    assert page.has_css?('select#available_cfs')
  end

  def test_disabled_fields
    visit new_custom_field_path type: 'IssueCustomField'

    within('#custom_field_form') do
      select 'Float', from: 'Format'
      page.fill_in('Name', with: 'Computed')
    end

    assert formula_element.disabled?
    assert available_cfs_element.disabled?
  end

  def test_fields_enabling
    visit new_custom_field_path type: 'IssueCustomField'

    within('#custom_field_form') do
      select 'Float', from: 'Format'
      page.fill_in('Name', with: 'Computed')
    end

    computed_element.click
    refute formula_element.disabled?
    refute available_cfs_element.disabled?

    computed_element.click
    assert formula_element.disabled?
    assert available_cfs_element.disabled?
  end

  def test_common_custom_field_has_no_computed_fields
    visit edit_custom_field_path id: 1

    assert page.has_no_css?('#custom_field_is_computed')
    assert page.has_no_css?('#custom_field_formula')
    assert page.has_no_css?('#available_cfs')
  end

  def test_create_computed_custom_field
    formula = 'sum(cfs[6],cfs[6])'
    visit new_custom_field_path type: 'IssueCustomField'
    within('#custom_field_form') do
      select 'Float', from: 'Format'
      page.fill_in('Name', with: 'Computed')
      computed_element.click
      page.fill_in('Formula', with: formula)
      # click_button 'Create' would match both 'Create' and 'Create and continue' buttons
      find('input[name=commit]').click
    end
    assert page.has_text?('Successful creation')

    visit edit_custom_field_path(CustomField.last)
    assert_equal formula, formula_element.value
    assert computed_element.disabled?
    refute formula_element.disabled?
    refute available_cfs_element.disabled?
  end

  test 'available cfs if any' do
    visit new_custom_field_path type: 'IssueCustomField'
    within('#custom_field_form') do
      select 'Float', from: 'Format'
      page.fill_in('Name', with: 'Computed')
      computed_element.click
      find(:css, '#available_cfs').find(:option, 6).double_click
    end
    assert_equal 'cfs[6]', formula_element.value
    assert_equal IssueCustomField.computable.size, page.all('#available_cfs option').size
  end

  test 'available cfs if none' do
    visit new_custom_field_path type: 'TimeEntryCustomField'
    assert page.has_no_css?('#available_cfs')
  end

  private

  def computed_element
    page.first('#custom_field_is_computed')
  end

  def formula_element
    page.first('#custom_field_formula')
  end

  def available_cfs_element
    page.first('#available_cfs')
  end
end
