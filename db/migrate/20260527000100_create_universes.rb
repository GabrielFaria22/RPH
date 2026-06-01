class CreateUniverses < ActiveRecord::Migration[7.1]
  def change
    create_table :universes do |t|
      t.string :name, null: false
      t.string :genre, null: false, default: 'other'
      t.text :description
      t.string :portrait_image_description, limit: 140
      t.string :cover_image_description, limit: 140
      t.string :banner_image_description, limit: 140
      t.string :crest_image_description, limit: 140
      t.string :misc_images_description, limit: 140
      t.boolean :public, null: false, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :universes, [:user_id, :name]
    add_index :universes, :genre
    add_index :universes, :public
  end
end
