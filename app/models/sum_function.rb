class SumFunction < BaseFunction 
  def initialize(arguments:, context:)
    super
    @pattern = Regexp.new('(cfs\[\d+\])')
  end

  def calculate
  byebug
    # do the math
  end

  def validate
   # arguments exist
   # arguments are valid for this calculation
  end

  def available_operators
    %w[+ -]
  end

  def available_delimiters
    %w[;]
  end
end
