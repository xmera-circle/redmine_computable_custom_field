require File.expand_path('../../test_helper', __FILE__)

module ComputedCustomField
  class CustomFieldCalculatorTest < ActiveSupport::TestCase
    test 'should return a valid operator' do
      calculator = CustomFieldCalculator.new('cfs[6]+cfs[6]')
      assert_equal '+', calculator.operator
    end

    test 'should return nil if operator invalid' do
      calculator = CustomFieldCalculator.new('cfs[6]~cfs[6]')
      assert_nil calculator.operator
    end

    test 'should return custom_field ids' do
      calculator = CustomFieldCalculator.new('cfs[6]+cfs[6]')
      assert %w[6 6], calculator.cf_ids
    end
  end
end