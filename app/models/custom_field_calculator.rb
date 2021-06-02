class CustomFieldCalculator
  attr_reader :formula, :reg_expr

  def initialize(formula)
    @formula = formula
    @reg_expr = Regexp.new('(cfs\[\d+\])(\+|\-|\/|\*)(cfs\[\d+\])')
  end

  def calculate 
    case operator
      when '+'
        cf_values.sum
      when '-'
        negativ = [cf_values.first, -cf_values.last]
        negativ.sum
    end
  end

  ##
  # Only for validation purposes
  #
  def cf_values
    cf_ids.each_with_object([]) do |cf_id, values|
      field = grouped_cf[cf_id]
      field_value = field ? field.first.cast_value(1) : -2
      values << (field_value.is_a?(Integer) ? field_value : -2)
    end
  end

  def cf_ids
    ids = items.map do |item|
      item.scan(/cfs\[(\d+)\]/)
    end
    ids.flatten!
    ids.compact!
    ids.map!(&:to_i)
  end

  def items
    formula.scan(reg_expr).flatten
  end

  def operator
    (items & valid_operators).first
  end

  def valid_operators
    %w[+ - * /]
  end

  def valid_result?
    [2, 0, 1].include? calculate
  end

  def grouped_cf
    CustomField.all.group_by(&:id)
  end

  def validate
    return true if formula.blank?

    raise 'Unvalid operator' unless operator
    raise 'Unvalid custom fields' unless valid_result?
  end

end