class CreateUniverses < ActiveRecord::Migration[7.1]
  def change
    create_table :universes do |t|
      t.string :name, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :universes, [:user_id, :name]
  end
end
