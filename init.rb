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

require File.expand_path('lib/computable_custom_field', __dir__)

Redmine::Plugin.register :redmine_computable_custom_field do
  name 'Computable custom field'
  author 'Yakov Annikov, Liane Hampe'
  description 'Simple calculations with custom fields'
  version '3.0.4'

  requires_redmine version_or_higher: '4.2.1'
  requires_redmine_plugin :advanced_plugin_helper, version_or_higher: '0.2.0'
end

ComputableCustomField.setup
