# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_14_160040) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "paypal_email"
    t.integer "balance", default: 6000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "batches", force: :cascade do |t|
    t.string "paypal_id"
    t.integer "amount"
    t.integer "seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charges", force: :cascade do |t|
    t.string "gateway_charge_id"
    t.integer "amount"
    t.integer "amount_refunded"
    t.string "balance_transaction"
    t.boolean "captured"
    t.integer "created"
    t.string "currency"
    t.string "description"
    t.boolean "success"
    t.bigint "account_id"
    t.integer "seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_charges_on_account_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount"
    t.integer "seconds"
    t.string "currency"
    t.bigint "account_id"
    t.bigint "batch_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_payments_on_account_id"
    t.index ["batch_id"], name: "index_payments_on_batch_id"
  end

  create_table "plays", force: :cascade do |t|
    t.bigint "account_id"
    t.bigint "video_id"
    t.integer "duration"
    t.integer "price", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_plays_on_account_id"
    t.index ["video_id"], name: "index_plays_on_video_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "video_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["video_id"], name: "index_taggings_on_video_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "full_name"
    t.boolean "admin", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "paypal_email"
    t.string "category", default: "viewer"
    t.string "referrer"
    t.string "link"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "duration"
    t.integer "price", default: 1
    t.boolean "approved", default: false
    t.text "clip_data"
    t.integer "balance", default: 0
    t.integer "views", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false
    t.string "image"
    t.boolean "removed", default: false
    t.boolean "suspended", default: false
    t.boolean "featured", default: false
    t.string "imdb_id"
    t.integer "runtime"
    t.string "rating"
    t.string "language"
    t.date "published_at"
    t.string "s3_id"
    t.integer "rank"
    t.string "director"
    t.bigint "account_id"
    t.string "storage_url"
    t.string "mux_asset_id"
    t.string "mux_playback_id"
    t.index ["account_id"], name: "index_videos_on_account_id"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "charges", "accounts"
  add_foreign_key "payments", "accounts"
  add_foreign_key "payments", "batches"
  add_foreign_key "plays", "accounts"
  add_foreign_key "plays", "videos"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "videos"
end
