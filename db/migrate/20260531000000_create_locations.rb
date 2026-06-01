class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :location_type
      t.text :brief_description
      t.text :full_description
      t.string :portrait_image_description, limit: 140
      t.string :cover_image_description, limit: 140
      t.string :banner_image_description, limit: 140
      t.string :crest_image_description, limit: 140
      t.string :misc_images_description, limit: 140
      t.boolean :public, default: false, null: false
      t.references :universe, foreign_key: true
      t.references :world, foreign_key: true
      t.references :parent_location, foreign_key: { to_table: :locations }

      t.timestamps
    end

    add_index :locations, :public
    add_index :locations, [:universe_id, :name]
    add_index :locations, [:world_id, :name]
    add_index :locations, [:parent_location_id, :name]
  end
end
