class FormulaSyntaxCheck
  def initialize(name:, fragment:)
    @name = name
    @fragment = fragment
  end

  def validate(record)
    return if record.errors.any?

    record.errors.add :base,'Invalid operator.' unless valid_syntax?
  end

  private

  attr_reader :name, :fragment

  def valid_syntax?
    (operators & operator).present? || (delimiters & delimiter).present?
  end

  def operator
    fragment.operator
  end

  def operators
    math_function.available_operators
  end

  def delimiter
    fragment.delimiter
  end

  def delimiters
    math_function.available_delimiters
  end

  def math_function
    klass.new(arguments: fragment.arguments, context: nil)
  end

  def klass
    name.present? ? "#{name.classify}Function".constantize : NullFunction
  end
end
