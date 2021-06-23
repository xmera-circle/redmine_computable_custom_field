class Formula
  def self.available_names
    %w[sum min max product division custom]
  end

  def self.name_pattern
    available_names.join('|')
  end

  def initialize(expression:)
    @expression = expression
  end

  ##
  # @return [String] Name of the formula or empty String if nothing matches.
  #
  def name
    matched_data.to_s
  end

  ##
  # @return [String] Arguments of formula or empty String if there are no arguments.
  #
  def arguments
    matched_data.post_match.delete('()')
  end

  def validate(record)
    return if record.errors.any?

    return record.errors.add :base, 'unknown formula' unless name_available?
    return record.errors.add :base, 'unsupported formula' unless name_unsupported? record
  end

  private

  attr_reader :expression

  def matched_data
    expression.match(self.class.name_pattern) || empty_data
  end

  def empty_data
    ' '.match(Regexp.new('\s'))
  end

  def name_available?
    self.class.available_names.include? name
  end

  def name_unsupported?(record)
    field_format(record).supported_math_functions.include? name
  end

  def field_format(record)
    "Redmine::FieldFormat::#{record.field_format.classify}Format".constantize
  end
end
