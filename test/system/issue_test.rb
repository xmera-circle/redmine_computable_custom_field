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

class IssueTest < ApplicationSystemTestCase
  fixtures FixturesHelper.fixtures
  include MethodsHelper

  def setup
    super
    @field = field
    update_project(issue_custom_field_id: @field.id)
    Capybara.current_session.reset!
    log_user 'admin', 'admin'
  end

  test 'computed cfs should be readonly on new issue page' do
    visit new_issue_path project: project
    assert page.has_no_css?("issue_custom_field_values_#{@field.id}")
  end

  test 'computed cfs should be readonly on show issue page' do
    visit issue_path issue
    assert page.has_content?(@field.name)
  end

  test 'computed cfs should be readonly on edit issue page' do
    visit edit_issue_path issue
    assert page.has_no_css?("issue_custom_field_values_#{@field.id}")
  end

  private

  def field
    field_with_int_format(formula: 'sum(cfs[6], cfs[6]')
  end

  def update_project(issue_custom_field_id:)
    project.issue_custom_field_ids << issue_custom_field_id
  end
end
