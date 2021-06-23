class FormulaContext
  def initialize(field_ids:, available_fields:)
    @field_ids = field_ids
    @available_fields = available_fields
  end

  def cfs
    cfv_by_id(field_ids)
    # vals = cfs_ids.each_with_object({}) do |cf_id, hash|
    #   cfv = grouped_cf[cf_id]&.first
    #   value = cfv ? cfv.custom_field.cast_value(cfv.value) : nil
    #   hash[cf_id] = value
    # end
    # vals
  end

  def sanitize
    #
  end

  def validate
    # fields are determined by the given arguments
    # all fields need to have the same format type as the computed field
    # the fields needs to be computable at all
    # 

  end

  private

  attr_reader :field_ids, :available_fields

  ##
  # Available fields grouped by id. They can be either of class CustomField
  # or of class CustomFieldValues.
  #
  def grouped_cf
    available_fields.computable_group_by_id
  end

end
