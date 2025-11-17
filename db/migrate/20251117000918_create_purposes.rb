class CreatePurposes < ActiveRecord::Migration[8.1]
  def change
    create_table :purposes do |t|
      t.string :name

      t.timestamps
    end
  end
end
