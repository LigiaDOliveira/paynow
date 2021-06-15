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

ActiveRecord::Schema.define(version: 2021_06_14_233442) do

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins_paynow", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_paynow_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_paynow_on_reset_password_token", unique: true
  end

  create_table "boletos", force: :cascade do |t|
    t.integer "bank_code"
    t.integer "agency"
    t.integer "account"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.integer "payment_method_id"
    t.index ["company_id"], name: "index_boletos_on_company_id"
    t.index ["payment_method_id"], name: "index_boletos_on_payment_method_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "email"
    t.string "cnpj"
    t.string "corporate_name"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string "cc_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.integer "payment_method_id"
    t.index ["company_id"], name: "index_credit_cards_on_company_id"
    t.index ["payment_method_id"], name: "index_credit_cards_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.decimal "charging_fee"
    t.decimal "maximum_charge"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "pay_type"
  end

  create_table "pixes", force: :cascade do |t|
    t.string "pix_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "company_id"
    t.integer "payment_method_id"
    t.integer "bank_code"
    t.index ["company_id"], name: "index_pixes_on_company_id"
    t.index ["payment_method_id"], name: "index_pixes_on_payment_method_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "admin", default: false
    t.integer "company_id"
    t.string "token"
    t.index ["company_id"], name: "index_staffs_on_company_id"
    t.index ["email"], name: "index_staffs_on_email", unique: true
    t.index ["reset_password_token"], name: "index_staffs_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "boletos", "companies"
  add_foreign_key "boletos", "payment_methods"
  add_foreign_key "credit_cards", "companies"
  add_foreign_key "credit_cards", "payment_methods"
  add_foreign_key "pixes", "companies"
  add_foreign_key "pixes", "payment_methods"
  add_foreign_key "staffs", "companies"
end
