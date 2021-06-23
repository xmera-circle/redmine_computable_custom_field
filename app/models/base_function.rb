class BaseFunction
  def initialize(arguments:, context: nil)
    @arguments = arguments
    @context = context
    @pattern = nil
  end

  def calculate
    raise NotImplementedError, "#{__method__} needs to be implemented"
  end

  def validate
    raise NotImplementedError, "#{__method__} needs to be implemented"
  end

  private

  attr_reader :arguments, :context, :pattern
end
