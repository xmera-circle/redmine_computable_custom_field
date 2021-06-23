class NullFunction
  def initialize(arguments: nil, context: nil)
    @arguments = arguments
    @context = context
  end

  def validate
    false
  end

  def sanitize
    ''
  end

  def available_operators
    []
  end
end
