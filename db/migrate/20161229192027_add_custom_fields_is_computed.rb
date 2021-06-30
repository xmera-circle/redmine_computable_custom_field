class AddCustomFieldsIsComputed < ActiveRecord::Migration[5.2]
  def up
    add_column :custom_fields, :is_computed, :boolean, default: false
  end

  def down
    remove_column :custom_fields, :is_computed
  end
end
