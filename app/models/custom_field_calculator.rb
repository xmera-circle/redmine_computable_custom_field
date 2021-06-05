class CustomFieldCalculator
  attr_reader :formula, :reg_expr, :cf_pattern, :op_pattern, :fields

  def initialize(formula:, fields: CustomField.computable)
    @formula = formula
    @reg_expr = Regexp.new('(cfs\[\d+\])(\+|\-|\/|\*)(cfs\[\d+\])')
    @cf_pattern = Regexp.new('(cfs\[\d+\])')
    @op_pattern = Regexp.new('(\+|\-|\/|\*)')
    @fields = fields
  end

  def calculate
    eval sanitized_formula.join
  end

  def validate
    return true if formula.blank?

    raise 'Unvalid operator' unless valid_operators?
    raise 'Unvalid custom fields' unless valid_field?
    raise 'Unvalid custom fields' unless valid_result?
  end

  private

  def cfs
    vals = cf_ids.each_with_object({}) do |cf_id, hash|
      cfv = grouped_cf[cf_id].first
      value = case cfv.is_a? CustomField
              when true
                cfv ? cfv.cast_value(1) : -2
              when false
                cfv ? cfv.custom_field.cast_value(cfv.value) : nil
              end
      hash[cf_id] = value
    end
    vals
  end

  def cf_ids
    ids = extracted_cfs.map do |item|
      item.scan(/cfs\[(\d+)\]/)
    end
    ids.flatten!
    ids.map!(&:to_i)
  end

  def items
    formula.scan(reg_expr).flatten
  end

  ##
  # @return [Array(String)] All valid elements each as entry in an array.
  #
  def sanitized_formula
    extracted_cfs.zip(extracted_ops).flatten.compact
  end

  def extracted_cfs
    formula.scan(cf_pattern).flatten
  end

  def extracted_ops
    formula.scan(op_pattern).flatten
  end

  def valid_operators?
    extracted_ops.present?
  end

  def available_operators
    %w[+ - * /]
  end

  def valid_result?
    [2, 0, 1].include? calculate
  end

  def valid_field?
    (formats.uniq - %w[int float]).blank?
  end

  def grouped_cf
    return fields.group_by(&:id) if fields.is_a? ActiveRecord::Relation

    fields.group_by { |cfv| cfv.custom_field.id }
  end

  def formats
    return fields.map(&:field_format) if fields.is_a? ActiveRecord::Relation

    fields.map(&:custom_field).map(&:field_format)
  end
end
