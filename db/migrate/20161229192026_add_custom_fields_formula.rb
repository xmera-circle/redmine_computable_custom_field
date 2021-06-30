class AddCustomFieldsFormula < ActiveRecord::Migration[5.2]
  def up
    add_column :custom_fields, :formula, :text
  end

  def down
    remove_column :custom_fields, :formula
  end
end