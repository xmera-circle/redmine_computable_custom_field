class MathFunction
  def initialize(name:, arguments:, context:)
    @name = name
    @arguments = arguments
    @context = context
  end

  def calculate
    math_function.calculate
  end

  def validate
    math_function.validate
  end

  def required_operators
    math_function.required_operators
  end

  private

  attr_reader :name

  def math_function
    klass.new(arguments: arguments, context: context)
  end

  def klass
    name.present? ? "#{name.classify}Function".constantize : NullFunction
  end
end
