class CreateFactionsAndFamilies < ActiveRecord::Migration[7.1]
  def change
    create_table :factions do |t|
      t.string :name, null: false
      t.text :description
      t.string :portrait_image_description, limit: 140
      t.string :cover_image_description, limit: 140
      t.string :banner_image_description, limit: 140
      t.string :crest_image_description, limit: 140
      t.string :misc_images_description, limit: 140
      t.boolean :public, null: false, default: false
      t.references :universe, null: false, foreign_key: true
      t.references :leader_character, null: false, foreign_key: { to_table: :characters }

      t.timestamps
    end

    add_index :factions, :public
    add_index :factions, [:universe_id, :name]

    create_table :families do |t|
      t.string :name, null: false
      t.text :description
      t.string :portrait_image_description, limit: 140
      t.string :cover_image_description, limit: 140
      t.string :banner_image_description, limit: 140
      t.string :crest_image_description, limit: 140
      t.string :misc_images_description, limit: 140
      t.boolean :public, null: false, default: false
      t.references :universe, null: false, foreign_key: true
      t.references :leader_character, null: false, foreign_key: { to_table: :characters }
      t.references :faction, foreign_key: true

      t.timestamps
    end

    add_index :families, :public
    add_index :families, [:universe_id, :name]

    add_reference :family_trees, :family, foreign_key: true, index: { unique: true }
    add_reference :characters, :family, foreign_key: true
    add_reference :characters, :faction, foreign_key: true
  end
end
