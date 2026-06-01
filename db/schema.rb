# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_05_31_000000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "characters", force: :cascade do |t|
    t.string "name", null: false
    t.string "full_name"
    t.string "nickname"
    t.string "age"
    t.string "appearance"
    t.string "occupation"
    t.text "description"
    t.text "story"
    t.string "portrait_image_description", limit: 140
    t.string "cover_image_description", limit: 140
    t.string "banner_image_description", limit: 140
    t.string "crest_image_description", limit: 140
    t.string "misc_images_description", limit: 140
    t.boolean "public", default: false, null: false
    t.bigint "universe_id", null: false
    t.bigint "world_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "family_id"
    t.bigint "faction_id"
    t.index ["faction_id"], name: "index_characters_on_faction_id"
    t.index ["family_id"], name: "index_characters_on_family_id"
    t.index ["public"], name: "index_characters_on_public"
    t.index ["universe_id", "name"], name: "index_characters_on_universe_id_and_name"
    t.index ["universe_id"], name: "index_characters_on_universe_id"
    t.index ["world_id", "name"], name: "index_characters_on_world_id_and_name"
    t.index ["world_id"], name: "index_characters_on_world_id"
  end

  create_table "faction_relations", force: :cascade do |t|
    t.bigint "faction_id", null: false
    t.bigint "related_faction_id", null: false
    t.string "relation_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faction_id", "related_faction_id", "relation_type"], name: "index_faction_relations_on_faction_pair_and_type", unique: true
    t.index ["faction_id"], name: "index_faction_relations_on_faction_id"
    t.index ["related_faction_id"], name: "index_faction_relations_on_related_faction_id"
  end

  create_table "factions", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "portrait_image_description", limit: 140
    t.string "cover_image_description", limit: 140
    t.string "banner_image_description", limit: 140
    t.string "crest_image_description", limit: 140
    t.string "misc_images_description", limit: 140
    t.boolean "public", default: false, null: false
    t.bigint "universe_id", null: false
    t.bigint "leader_character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_character_id"], name: "index_factions_on_leader_character_id"
    t.index ["public"], name: "index_factions_on_public"
    t.index ["universe_id", "name"], name: "index_factions_on_universe_id_and_name"
    t.index ["universe_id"], name: "index_factions_on_universe_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "portrait_image_description", limit: 140
    t.string "cover_image_description", limit: 140
    t.string "banner_image_description", limit: 140
    t.string "crest_image_description", limit: 140
    t.string "misc_images_description", limit: 140
    t.boolean "public", default: false, null: false
    t.bigint "universe_id", null: false
    t.bigint "leader_character_id", null: false
    t.bigint "faction_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["faction_id"], name: "index_families_on_faction_id"
    t.index ["leader_character_id"], name: "index_families_on_leader_character_id"
    t.index ["public"], name: "index_families_on_public"
    t.index ["universe_id", "name"], name: "index_families_on_universe_id_and_name"
    t.index ["universe_id"], name: "index_families_on_universe_id"
  end

  create_table "family_relations", force: :cascade do |t|
    t.bigint "family_id", null: false
    t.bigint "related_family_id", null: false
    t.string "relation_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id", "related_family_id", "relation_type"], name: "index_family_relations_on_family_pair_and_type", unique: true
    t.index ["family_id"], name: "index_family_relations_on_family_id"
    t.index ["related_family_id"], name: "index_family_relations_on_related_family_id"
  end

  create_table "family_trees", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "portrait_image_description", limit: 140
    t.string "cover_image_description", limit: 140
    t.string "banner_image_description", limit: 140
    t.string "crest_image_description", limit: 140
    t.string "misc_images_description", limit: 140
    t.boolean "public", default: false, null: false
    t.jsonb "layout", default: {}, null: false
    t.bigint "universe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "family_id"
    t.index ["family_id"], name: "index_family_trees_on_family_id", unique: true
    t.index ["public"], name: "index_family_trees_on_public"
    t.index ["universe_id", "name"], name: "index_family_trees_on_universe_id_and_name"
    t.index ["universe_id"], name: "index_family_trees_on_universe_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", null: false
    t.string "location_type"
    t.text "brief_description"
    t.text "full_description"
    t.string "portrait_image_description", limit: 140
    t.string "cover_image_description", limit: 140
    t.string "banner_image_description", limit: 140
    t.string "crest_image_description", limit: 140
    t.string "misc_images_description", limit: 140
    t.boolean "public", default: false, null: false
    t.bigint "universe_id"
    t.bigint "world_id"
    t.bigint "parent_location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_location_id", "name"], name: "index_locations_on_parent_location_id_and_name"
    t.index ["parent_location_id"], name: "index_locations_on_parent_location_id"
    t.index ["public"], name: "index_locations_on_public"
    t.index ["universe_id", "name"], name: "index_locations_on_universe_id_and_name"
    t.index ["universe_id"], name: "index_locations_on_universe_id"
    t.index ["world_id", "name"], name: "index_locations_on_world_id_and_name"
    t.index ["world_id"], name: "index_locations_on_world_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "relation", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "related_character_id", null: false
    t.string "relation_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id", "related_character_id", "relation_type"], name: "index_relation_on_character_pair_and_type", unique: true
    t.index ["character_id"], name: "index_relation_on_character_id"
    t.index ["related_character_id"], name: "index_relation_on_related_character_id"
  end

  create_table "universes", force: :cascade do |t|
    t.string "name", null: false
    t.string "genre", default: "other", null: false
    t.text "description"
    t.string "portrait_image_description", limit: 140
    t.string "cover_image_description", limit: 140
    t.string "banner_image_description", limit: 140
    t.string "crest_image_description", limit: 140
    t.string "misc_images_description", limit: 140
    t.boolean "public", default: false, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["genre"], name: "index_universes_on_genre"
    t.index ["public"], name: "index_universes_on_public"
    t.index ["user_id", "name"], name: "index_universes_on_user_id_and_name"
    t.index ["user_id"], name: "index_universes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "jti", null: false
    t.string "profile_type", default: "regular", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["profile_type"], name: "index_users_on_profile_type"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "worlds", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "portrait_image_description", limit: 140
    t.string "cover_image_description", limit: 140
    t.string "banner_image_description", limit: 140
    t.string "crest_image_description", limit: 140
    t.string "misc_images_description", limit: 140
    t.boolean "public", default: false, null: false
    t.bigint "universe_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["public"], name: "index_worlds_on_public"
    t.index ["universe_id", "name"], name: "index_worlds_on_universe_id_and_name"
    t.index ["universe_id"], name: "index_worlds_on_universe_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "characters", "factions"
  add_foreign_key "characters", "families"
  add_foreign_key "characters", "universes"
  add_foreign_key "characters", "worlds"
  add_foreign_key "faction_relations", "factions"
  add_foreign_key "faction_relations", "factions", column: "related_faction_id"
  add_foreign_key "factions", "characters", column: "leader_character_id"
  add_foreign_key "factions", "universes"
  add_foreign_key "families", "characters", column: "leader_character_id"
  add_foreign_key "families", "factions"
  add_foreign_key "families", "universes"
  add_foreign_key "family_relations", "families"
  add_foreign_key "family_relations", "families", column: "related_family_id"
  add_foreign_key "family_trees", "families"
  add_foreign_key "family_trees", "universes"
  add_foreign_key "locations", "locations", column: "parent_location_id"
  add_foreign_key "locations", "universes"
  add_foreign_key "locations", "worlds"
  add_foreign_key "people", "users"
  add_foreign_key "relation", "characters"
  add_foreign_key "relation", "characters", column: "related_character_id"
  add_foreign_key "universes", "users"
  add_foreign_key "worlds", "universes"
end
