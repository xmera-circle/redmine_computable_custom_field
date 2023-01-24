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
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA

module ComputableCustomField
  module Extensions
    module FieldFormatPatch
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def supported_math_functions=(*math_functions)
          @supported_math_functions =
            (math_functions.flatten.map(&:to_s) & Formula.available_names)
        end

        def supported_math_functions
          @supported_math_functions || []
        end
      end
    end
  end
end
