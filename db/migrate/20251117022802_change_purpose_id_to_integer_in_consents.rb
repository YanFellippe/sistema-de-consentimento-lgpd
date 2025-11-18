class ChangePurposeIdToIntegerInConsents < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE consents SET purpose_id = purpose_id::integer WHERE purpose_id IS NOT NULL"
    change_column :consents, :purpose_id, :integer, using: 'purpose_id::integer'
    remove_foreign_key :consents, column: :purpose_id if foreign_key_exists?(:consents, column: :purpose_id)
    add_foreign_key :consents, :purposes
  end

  def down
    change_column :consents, :purpose_id, :string
  end
end
