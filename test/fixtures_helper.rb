# frozen_string_literal: true

#
# Redmine plugin for xmera called Computable Custom Field Plugin.
#
# Copyright (C) 2021 - 2022  Liane Hampe <liaham@xmera.de>, xmera.
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

module FixturesHelper
  def self.fixtures
    %i[projects users email_addresses roles members member_roles
       trackers projects_trackers enabled_modules issue_statuses issues
       enumerations custom_fields custom_values custom_fields_trackers
       watchers journals journal_details versions
       workflows]
  end
end
