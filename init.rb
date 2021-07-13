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

require 'computable_custom_field'

Redmine::Plugin.register :redmine_computable_custom_field do
  name 'Computable custom field'
  author 'Yakov Annikov, Liane Hampe'
  description 'Simple calculations with custom fields'
  version '3.0.1'

  requires_redmine version_or_higher: '4.2.1'
end

Rails.configuration.to_prepare do
  patch = ComputableCustomField::ModelPatch
  klasses = ComputableCustomField::MODELS
  klasses.each do |klass|
    klass.include patch unless klass.included_modules.include?(patch)
  end
end
