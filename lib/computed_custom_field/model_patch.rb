module ComputedCustomField
  module ModelPatch
    extend ActiveSupport::Concern

    included do
      before_validation :eval_computed_fields
    end

    private

    def eval_computed_fields
      custom_field_values.each do |value|
        next unless value.custom_field.is_computed?
        eval_computed_field value.custom_field
      end
    end

    def eval_computed_field(custom_field)
      value = CustomFieldCalculator.new(formula: custom_field.formula,
                                        fields: fields).calculate
      self.custom_field_values = {
        custom_field.id => prepare_computed_value(custom_field, value)
      }
    rescue Exception => e
      errors.add :base, l(:error_while_formula_computing,
                          custom_field_name: custom_field.name,
                          message: e.message)
    end

    def prepare_computed_value(custom_field, value)
      return value.map { |v| prepare_computed_value(custom_field, v) } if value.is_a? Array

      result = case custom_field.field_format
               when 'bool'
                 value.is_a?(TrueClass) ? '1' : '0'
               when 'int'
                 value.to_i
               else
                 value.respond_to?(:id) ? value.id : value
               end
      result.to_s
    end

    def fields
      custom_field_values
    end
  end
end
