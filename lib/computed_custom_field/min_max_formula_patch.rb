
module ComputedCustomField
  module MinMaxFormulaPatch
    def self.included(base)
      base.supported_math_functions = %w[min max]
    end
  end
end

unless Redmine::FieldFormat::EnumerationFormat
  .included_modules.include?(ComputedCustomField::MinMaxFormulaPatch)
  Redmine::FieldFormat::EnumerationFormat.include ComputedCustomField::MinMaxFormulaPatch
end
