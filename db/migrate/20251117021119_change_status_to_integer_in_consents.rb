class ChangeStatusToIntegerInConsents < ActiveRecord::Migration[8.1]
  def up
    # Remover a restrição NOT NULL temporariamente
    change_column_null :consents, :status, true
    
    # Limpar dados existentes
    execute "UPDATE consents SET status = NULL"
    
    # Alterar o tipo da coluna
    change_column :consents, :status, :integer, using: 'status::integer'
  end

  def down
    change_column :consents, :status, :string
  end
end
