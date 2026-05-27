class CreateWorlds < ActiveRecord::Migration[7.1]
  def change
    create_table :worlds do |t|
      t.string :name, null: false
      t.text :description
      t.references :universe, null: false, foreign_key: true

      t.timestamps
    end

    add_index :worlds, [:universe_id, :name]
  end
end
