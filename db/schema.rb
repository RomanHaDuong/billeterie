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

ActiveRecord::Schema[7.1].define(version: 2025_11_25_040116) do
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

  create_table "bookings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "offre_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "creneau"
    t.string "user_name"
    t.string "user_email"
    t.index ["offre_id"], name: "index_bookings_on_offre_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "favoris", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "offre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offre_id"], name: "index_favoris_on_offre_id"
    t.index ["user_id"], name: "index_favoris_on_user_id"
  end

  create_table "fournisseurs", force: :cascade do |t|
    t.string "bio"
    t.bigint "user_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "instagram"
    t.string "offinity"
    t.string "linkedin"
    t.index ["user_id"], name: "index_fournisseurs_on_user_id"
  end

  create_table "offres", force: :cascade do |t|
    t.bigint "fournisseur_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_prevue"
    t.string "titre"
    t.string "intervenant"
    t.string "descriptif"
    t.string "causes"
    t.string "valeur_apportee"
    t.string "duree"
    t.string "besoin_espace"
    t.string "besoin_logistique"
    t.string "autre_commentaire"
    t.string "salle"
    t.string "categories"
    t.integer "place"
    t.bigint "secondary_fournisseur_id"
    t.index ["fournisseur_id"], name: "index_offres_on_fournisseur_id"
    t.index ["secondary_fournisseur_id"], name: "index_offres_on_secondary_fournisseur_id"
  end

  create_table "text_blocks", force: :cascade do |t|
    t.string "key"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "google_token"
    t.string "google_refresh_token"
    t.boolean "admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "offres"
  add_foreign_key "bookings", "users"
  add_foreign_key "favoris", "offres"
  add_foreign_key "favoris", "users"
  add_foreign_key "fournisseurs", "users"
  add_foreign_key "offres", "fournisseurs"
  add_foreign_key "offres", "fournisseurs", column: "secondary_fournisseur_id"
end
