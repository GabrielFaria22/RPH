class CreateFamilyAndFactionRelations < ActiveRecord::Migration[7.1]
  def change
    create_table :family_relations do |t|
      t.references :family, null: false, foreign_key: true
      t.references :related_family, null: false, foreign_key: { to_table: :families }
      t.string :relation_type, null: false

      t.timestamps
    end

    add_index :family_relations,
      [:family_id, :related_family_id, :relation_type],
      unique: true,
      name: :index_family_relations_on_family_pair_and_type

    create_table :faction_relations do |t|
      t.references :faction, null: false, foreign_key: true
      t.references :related_faction, null: false, foreign_key: { to_table: :factions }
      t.string :relation_type, null: false

      t.timestamps
    end

    add_index :faction_relations,
      [:faction_id, :related_faction_id, :relation_type],
      unique: true,
      name: :index_faction_relations_on_faction_pair_and_type
  end
end
