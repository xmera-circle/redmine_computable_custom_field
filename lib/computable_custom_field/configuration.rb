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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

module ComputableCustomField
  module Configuration
    class << self
      attr_reader :formats, :formulas

      def models=(*values)
        @models = values.flatten
      end

      def models
        @models.map(&:constantize)
      end

      def formats=(*values)
        @formats = values.flatten
      end

      def formulas=(*values)
        @formulas = values.flatten
      end
    end

    class Support
      attr_reader :format, :formulas

      def initialize(format:, formulas:)
        @format = format
        @formulas = formulas
      end

      def klass
        "Redmine::FieldFormat::#{format.classify}Format".constantize
      end
    end
  end
end
