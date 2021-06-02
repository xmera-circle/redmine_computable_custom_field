module ComputedCustomField
  class FormulaValidator < ActiveModel::Validator
    def validate(record)
      object = custom_field_instance(record)
      define_validate_record_method(object)
      object.validate_record record, reg_expr
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
      def object.validate_record(record, reg_expr)
        CustomFieldCalculator.new(record.formula).validate
        # return true if record.formula.blank?

        # grouped_cfs = CustomField.all.group_by(&:id)
        # items = record.formula.scan(reg_expr).flatten
        # operator = nil
        # cf_ids = []
        # items.each do |item|
        #   id = item.scan(/cfs\[(\d+)\]/)
        #   if id.blank?
        #     operator = item
        #   else
        #     cf_ids << id
        #   end
        # end
        # cf_ids.flatten!
        # cf_ids.map!(&:to_i)

        # raise 'Unvalid operator' unless operator

        # cfs = cf_ids.each_with_object([]) do |cf_id, values|
        #   field = grouped_cfs[cf_id]
        #   field_value = field ? field.first.cast_value(1) : -2
        #   values << (field_value.is_a?(Integer) ? field_value : -2)
        # end
        # result = case operator
        #   when '+'
        #     cfs.sum
        #   when '-'
        #     negativ = [cfs.first, -cfs.last]
        #     negativ.sum
        # end
        # raise 'Unvalid custom fields' unless [2, 0, 1].include? result
      end
    end

    def reg_expr
      Regexp.new('(cfs\[\d+\])(\+|\-|\/|\*)(cfs\[\d+\])')
    end
  end
end
