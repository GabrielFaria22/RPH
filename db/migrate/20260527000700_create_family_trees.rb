class CreateFamilyTrees < ActiveRecord::Migration[7.1]
  def change
    create_table :family_trees do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :public, null: false, default: false
      t.jsonb :layout, null: false, default: {}
      t.references :universe, null: false, foreign_key: true

      t.timestamps
    end

    add_index :family_trees, :public
    add_index :family_trees, [:universe_id, :name]
  end
end
