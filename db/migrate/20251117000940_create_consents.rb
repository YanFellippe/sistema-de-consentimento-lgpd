class CreateConsents < ActiveRecord::Migration[8.1]
  def change
    create_table :consents do |t|
      t.references :user, null: false, foreign_key: true
      t.references :purpose, null: false, foreign_key: true
      t.integer :status
      t.datetime :granted_at
      t.datetime :revoked_at

      t.timestamps
    end
  end
end
