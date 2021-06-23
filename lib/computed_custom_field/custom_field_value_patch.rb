module ComputedCustomField
  module CustomFieldValuePatch
    def self.included(base)
      base.include(InstanceMethods)
    end

    module InstanceMethods
      def computable_group_by_id
        custom_field_values.group_by { |cfv| cfv.custom_field.id }
      end
    end
  end
end

unless CustomFieldValue.included_modules.include?(ComputedCustomField::CustomFieldValuePatch)
  CustomFieldValue.include ComputedCustomField::CustomFieldValuePatch
end
