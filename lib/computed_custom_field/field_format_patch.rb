module ComputedCustomField
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

unless Redmine::FieldFormat::Base.included_modules.include?(ComputedCustomField::FieldFormatPatch)
  Redmine::FieldFormat::Base.include ComputedCustomField::FieldFormatPatch
end
