class FormulaValidator < ActiveModel::Validator
  def validate(record)
    formula = Formula.new(expression: record.formula)
    formula.validate(record)
    fragment = FormulaFragment.new(arguments: formula.arguments)
    fragment.validate(record)
    syntax = FormulaSyntaxCheck.new(name: formula.name, fragment: fragment)
    syntax.validate(record) # <- each formula by name should know what syntax it needs
    # valid custom fields? 
  end
end
