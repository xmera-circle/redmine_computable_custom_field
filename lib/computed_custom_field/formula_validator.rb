module ComputedCustomField
  class FormulaValidator < ActiveModel::Validator
    def validate(record)
      object = custom_field_instance(record)
      define_validate_record_method(object)
      object.validate_record record
    rescue Exception => e
      record.errors[:formula] << e.message
    end

    private

    def custom_field_instance(record)
      record.type.sub('CustomField', '').constantize.new
    end

    def grouped_custom_fields
      @grouped_custom_fields ||= CustomField.all.group_by(&:id)
    end

    def custom_field_ids(record)
      record.formula.scan(/cfs\[(\d+)\]/).flatten.map(&:to_i)
    end

    def define_validate_record_method(object)
      def object.validate_record(record)
        CustomFieldCalculator.new(formula: record.formula).validate
      end
    end
  end
end
