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

ActiveRecord::Schema[7.1].define(version: 2024_12_23_101026) do
  create_table "bookings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "offre_id", null: false
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offre_id"], name: "index_bookings_on_offre_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "favoris", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "offre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["offre_id"], name: "index_favoris_on_offre_id"
    t.index ["user_id"], name: "index_favoris_on_user_id"
  end

  create_table "fournisseurs", force: :cascade do |t|
    t.string "bio"
    t.integer "user_id", null: false
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_fournisseurs_on_user_id"
  end

  create_table "offres", force: :cascade do |t|
    t.integer "price"
    t.integer "fournisseur_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fournisseur_id"], name: "index_offres_on_fournisseur_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "offres"
  add_foreign_key "bookings", "users"
  add_foreign_key "favoris", "offres"
  add_foreign_key "favoris", "users"
  add_foreign_key "fournisseurs", "users"
  add_foreign_key "offres", "fournisseurs"
end
