class FormulaFragment
  attr_reader :arguments

  def initialize(arguments:)
    @arguments = arguments
  end

  def ids
    cf_ids = extracted_cfs.map do |item|
      item.scan(id_pattern)
    end
    cf_ids.flatten!
    cf_ids.map!(&:to_i)
  end

  def delimiter
    arguments.scan(del_pattern).flatten
  end

  def operator
    arguments.scan(op_pattern).flatten
  end

  def validate(record)
    return if record.errors.any?
    return record.errors.add :base, 'no valid arguments given' if ids.blank?
    return if ids.count < 2

    record.errors.add :base, 'invalid arguments' if operator.blank? && delimiter.blank?
  end

  private

  def extracted_cfs
    arguments.scan(cfs_pattern).flatten
  end

  def cfs_pattern
    Regexp.new('(cfs\[\d+\])')
  end

  def id_pattern
    Regexp.new('cfs\[(\d+)\]')
  end

  def op_pattern
    Regexp.new('(\+|\-|\/|\*)')
  end

  def del_pattern
    Regexp.new('(\;)')
  end
end
