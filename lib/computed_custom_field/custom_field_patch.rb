module ComputedCustomField
  module CustomFieldPatch
    extend ActiveSupport::Concern

    included do
      before_validation -> { self.formula ||= '' }, if: :is_computed?
      validates_with FormulaValidator, if: :is_computed?
      safe_attributes 'is_computed', 'formula' if CustomField.respond_to? 'safe_attributes'
      scope :computable, -> { where(is_computed: false).where(field_format: ComputedCustomField::FORMATS) }
      scope :computable_group_by_id, -> { computable.group_by.map(&:id) }
    end

    def is_computed=(arg)
      # cannot change is_computed of a saved custom field
      super if new_record?
    end
  end
end

unless CustomField.included_modules
                  .include?(ComputedCustomField::CustomFieldPatch)
  CustomField.include ComputedCustomField::CustomFieldPatch
end
