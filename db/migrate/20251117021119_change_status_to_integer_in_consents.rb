class ChangeStatusToIntegerInConsents < ActiveRecord::Migration[8.1]
  def up
    change_column_null :consents, :status, true
    execute "UPDATE consents SET status = NULL"
    change_column :consents, :status, :integer, using: 'status::integer'
  end

  def down
    change_column :consents, :status, :string
  end
end
