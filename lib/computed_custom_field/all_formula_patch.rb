
module ComputedCustomField
  module AllFormulaPatch
    def self.included(base)
      base.supported_math_functions = Formula.available_names
    end
  end
end

ComputedCustomField::FORMATS.each do |format|
  klass = "Redmine::FieldFormat::#{format.capitalize}Format".constantize
  unless klass.included_modules.include?(ComputedCustomField::AllFormulaPatch)
    klass.include ComputedCustomField::AllFormulaPatch
  end
end
