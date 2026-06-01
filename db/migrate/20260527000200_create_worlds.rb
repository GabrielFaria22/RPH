class CreateWorlds < ActiveRecord::Migration[7.1]
  def change
    create_table :worlds do |t|
      t.string :name, null: false
      t.text :description
      t.string :portrait_image_description, limit: 140
      t.string :cover_image_description, limit: 140
      t.string :banner_image_description, limit: 140
      t.string :crest_image_description, limit: 140
      t.string :misc_images_description, limit: 140
      t.boolean :public, null: false, default: false
      t.references :universe, null: false, foreign_key: true

      t.timestamps
    end

    add_index :worlds, [:universe_id, :name]
    add_index :worlds, :public
  end
end
