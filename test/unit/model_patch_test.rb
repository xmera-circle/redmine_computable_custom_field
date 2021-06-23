require File.expand_path('../../test_helper', __FILE__)

class ModelPatchTest < ComputedCustomFieldTestCase
  def test_invalid_computation
  skip
    field = field_with_string_format
    message = 'Validation failed: Formula Unvalid custom fields'
    #assert_raise ActiveRecord::RecordInvalid, message do 
      field.update!(formula: 'cfs[1]+cfs[6]')
    #end
    issue.save
    assert_equal '', issue.custom_field_value(field.id)
  end

  def test_sum_with_int_format
    field = field_with_int_format
    formula = 'cfs[6]+cfs[6]+cfs[6]'
    result = (3 * issue.custom_field_value(6).to_f).truncate.to_s
    field.update_attribute(:formula, formula)
    issue.save
    assert_equal result, issue.custom_field_value(field.id)
  end

  def test_sum_with_float_format
    field = field_with_float_format
    formula = 'cfs[6]+cfs[6]-cfs[6]'
    result = (1 * issue.custom_field_value(6).to_f).to_s
    field.update_attribute(:formula, formula)
    issue.save
    assert_equal result, issue.custom_field_value(field.id)
  end

  def test_bool_computation
  skip
    field = field_with_bool_format
    field.update_attributes(formula: '1 == 1')
    issue.save
    assert_equal '1', issue.custom_field_value(field.id)

    field.update_attributes(formula: '1 == 0')
    issue.save
    assert_equal '0', issue.custom_field_value(field.id)
  end

  def test_string_computation
  skip
    field = field_with_string_format
    field.update_attribute(:formula, 'cfs[1]')
    issue.save
    assert_equal 'MySQL', issue.custom_field_value(field.id)
  end

  def test_list_computation
  skip
    field = field_with_list_format
    formula = '"Stable" if id == 3'
    field.update_attribute(:formula, formula)
    issue.save
    assert_equal 'Stable', issue.custom_field_value(field.id)
  end

  def test_multiple_list_computation
  skip
    field = field_with_list_format
    formula = "['Stable', 'Beta'] if id == #{issue.id}"
    field.update_attributes(formula: formula, multiple: true)
    issue.save!
    assert_equal %w[Beta Stable], issue.custom_field_value(field.id).sort
  end

  def test_float_computation
  skip
    field = field_with_float_format
    field.update_attribute(:formula, 'id/2.0')
    issue.save
    assert_equal '1.5', issue.custom_field_value(field.id)
  end

  def test_int_computation
  skip
    field = field_with_int_format
    field.update_attribute(:formula, 'id/2.0')
    issue.save
    assert_equal '1', issue.custom_field_value(field.id)
  end

  def test_date_computation
  skip
    field = field_with_date_format
    field.update_attribute(:formula, 'Date.new(2017, 1, 18)')
    issue.save
    assert_equal '2017-01-18', issue.custom_field_value(field.id)
  end

  def test_user_computation
  skip
    field = field_with_user_format
    field.update_attribute(:formula, 'assigned_to')
    issue.save
    assert_equal '3', issue.custom_field_value(field.id)
  end

  def test_multiple_user_computation
  skip
    field = field_with_user_format
    field.update_attributes(formula: '[assigned_to, author_id]', multiple: true)
    issue.save
    assert_equal %w[2 3], issue.custom_field_value(field.id).sort
  end

  def test_link_computation
  skip
    return if Redmine::VERSION.to_s < '2.5'
    field = field_with_link_format
    field.update_attribute(:formula, '"http://example.com/"')
    issue.save
    assert_equal 'http://example.com/', issue.custom_field_value(field.id)
  end
end
