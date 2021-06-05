require File.expand_path('../../test_helper', __FILE__)

module ComputedCustomField
  class CustomFieldCalculatorTest < ActiveSupport::TestCase
    test 'should confirm valid operators' do
      calculator = CustomFieldCalculator.new(formula: 'cfs[6]+cfs[6]-cfs[6]')
      assert calculator.send(:valid_operators?)
    end

    test 'should confirm invalid operator' do
      calculator = CustomFieldCalculator.new(formula: 'cfs[6]~cfs[6]')
      assert_not calculator.send(:valid_operators?)
    end

    test 'should return custom_field ids' do
      calculator = CustomFieldCalculator.new(formula: 'cfs[6]+cfs[6]')
      assert %w[6 6], calculator.send(:cf_ids)
    end
  end
end
