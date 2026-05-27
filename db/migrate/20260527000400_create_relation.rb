class CreateRelation < ActiveRecord::Migration[7.1]
  def change
    create_table :relation do |t|
      t.references :character, null: false, foreign_key: true
      t.references :related_character, null: false, foreign_key: { to_table: :characters }
      t.string :relation_type, null: false

      t.timestamps
    end

    add_index :relation,
      [:character_id, :related_character_id, :relation_type],
      unique: true,
      name: :index_relation_on_character_pair_and_type
  end
end
