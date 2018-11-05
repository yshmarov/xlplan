# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_11_04_222056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", limit: 144, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "employee_id"
    t.integer "balance", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_clients_on_employee_id"
    t.index ["person_id"], name: "index_clients_on_person_id"
  end

  create_table "employee_categories", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_employee_categories_on_category_id"
    t.index ["employee_id"], name: "index_employee_categories_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "location_id"
    t.string "specialization"
    t.date "employment_date"
    t.date "termination_date"
    t.integer "balance", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_employees_on_location_id"
    t.index ["person_id"], name: "index_employees_on_person_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "client_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "status", default: 0, null: false
    t.bigint "service_id"
    t.bigint "location_id"
    t.bigint "employee_id"
    t.string "service_name", default: "0", null: false
    t.string "service_description", default: "0", null: false
    t.integer "service_duration", default: 0, null: false
    t.integer "client_price", default: 0, null: false
    t.integer "employee_price", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_events_on_client_id"
    t.index ["employee_id"], name: "index_events_on_employee_id"
    t.index ["location_id"], name: "index_events_on_location_id"
    t.index ["service_id"], name: "index_events_on_service_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", limit: 144, null: false
    t.string "tel", limit: 144
    t.string "email", limit: 144
    t.string "address", limit: 255
    t.integer "balance", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "machines", force: :cascade do |t|
    t.string "name", limit: 144, null: false
    t.bigint "location_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_machines_on_location_id"
    t.index ["name"], name: "index_machines_on_name", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "first_name", limit: 144, null: false
    t.string "middle_name", limit: 144
    t.string "last_name", limit: 144, null: false
    t.date "date_of_birth"
    t.string "sex", default: "undisclosed"
    t.string "email"
    t.string "phone_number"
    t.string "address"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name", limit: 144, null: false
    t.string "description", limit: 255
    t.integer "duration", default: 30, null: false
    t.integer "client_price", default: 0, null: false
    t.integer "employee_percent", default: 100, null: false
    t.integer "employee_price", default: 0, null: false
    t.integer "quantity", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_services_on_category_id"
    t.index ["name"], name: "index_services_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.bigint "person_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["person_id"], name: "index_users_on_person_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "clients", "employees"
  add_foreign_key "clients", "people"
  add_foreign_key "employee_categories", "categories"
  add_foreign_key "employee_categories", "employees"
  add_foreign_key "employees", "locations"
  add_foreign_key "employees", "people"
  add_foreign_key "events", "clients"
  add_foreign_key "events", "employees"
  add_foreign_key "events", "locations"
  add_foreign_key "events", "services"
  add_foreign_key "machines", "locations"
  add_foreign_key "services", "categories"
  add_foreign_key "users", "people"
end
