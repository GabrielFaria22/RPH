class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.string :full_name
      t.string :nickname
      t.string :age
      t.string :appearance
      t.string :occupation
      t.text :description
      t.text :story
      t.references :universe, null: false, foreign_key: true
      t.references :world, foreign_key: true

      t.timestamps
    end

    add_index :characters, [:universe_id, :name]
    add_index :characters, [:world_id, :name]
  end
end
