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

ActiveRecord::Schema.define(version: 2018_11_20_152029) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "trackable_type"
    t.bigint "trackable_id"
    t.string "owner_type"
    t.bigint "owner_id"
    t.string "key"
    t.text "parameters"
    t.string "recipient_type"
    t.bigint "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["owner_type", "owner_id"], name: "index_activities_on_owner_type_and_owner_id"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["recipient_type", "recipient_id"], name: "index_activities_on_recipient_type_and_recipient_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "first_name", limit: 144, null: false
    t.string "middle_name", limit: 144
    t.string "last_name", limit: 144, null: false
    t.string "phone_number"
    t.string "email"
    t.date "date_of_birth"
    t.string "sex", default: "undisclosed"
    t.string "address"
    t.integer "status", default: 1, null: false
    t.integer "balance", default: 0, null: false
    t.bigint "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "jobs_count", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.index ["employee_id"], name: "index_clients_on_employee_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "employee_id"
    t.text "content"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["employee_id"], name: "index_comments_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name", limit: 144, null: false
    t.string "middle_name", limit: 144
    t.string "last_name", limit: 144, null: false
    t.string "phone_number"
    t.string "email"
    t.date "date_of_birth"
    t.string "sex", default: "undisclosed"
    t.string "address"
    t.integer "status", default: 1, null: false
    t.integer "balance", default: 0, null: false
    t.bigint "location_id"
    t.date "employment_date"
    t.date "termination_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "jobs_count", default: 0, null: false
    t.index ["location_id"], name: "index_employees_on_location_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "service_id"
    t.bigint "location_id"
    t.bigint "employee_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer "status", default: 0, null: false
    t.string "service_name", default: "0", null: false
    t.string "service_description", default: "0", null: false
    t.integer "service_duration", default: 0, null: false
    t.integer "client_price", default: 0, null: false
    t.integer "client_due_price", default: 0, null: false
    t.integer "employee_price", default: 0, null: false
    t.integer "employee_due_price", default: 0, null: false
    t.integer "created_by", default: 0, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_jobs_on_client_id"
    t.index ["employee_id"], name: "index_jobs_on_employee_id"
    t.index ["location_id"], name: "index_jobs_on_location_id"
    t.index ["service_id"], name: "index_jobs_on_service_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name", limit: 144, null: false
    t.string "tel", limit: 144
    t.string "email", limit: 144
    t.string "address", limit: 255
    t.integer "balance", default: 0, null: false
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "jobs_count", default: 0, null: false
    t.integer "workplaces_count", default: 0, null: false
    t.index ["name"], name: "index_locations_on_name", unique: true
  end

  create_table "service_categories", force: :cascade do |t|
    t.string "name", limit: 144, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "services_count", default: 0, null: false
  end

  create_table "services", force: :cascade do |t|
    t.string "name", limit: 144, null: false
    t.string "description", limit: 255
    t.integer "duration", default: 30, null: false
    t.integer "employee_percent", default: 100, null: false
    t.integer "quantity", default: 1, null: false
    t.integer "status", default: 1, null: false
    t.integer "client_price", default: 0, null: false
    t.integer "employee_price", default: 0, null: false
    t.bigint "service_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "jobs_count", default: 0, null: false
    t.index ["name"], name: "index_services_on_name", unique: true
    t.index ["service_category_id"], name: "index_services_on_service_category_id"
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "employee_id"
    t.bigint "service_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_skills_on_employee_id"
    t.index ["service_category_id"], name: "index_skills_on_service_category_id"
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
    t.bigint "employee_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["employee_id"], name: "index_users_on_employee_id"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workplaces", force: :cascade do |t|
    t.string "name", limit: 144, null: false
    t.bigint "location_id"
    t.integer "status", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_workplaces_on_location_id"
  end

  add_foreign_key "clients", "employees"
  add_foreign_key "comments", "employees"
  add_foreign_key "employees", "locations"
  add_foreign_key "jobs", "clients"
  add_foreign_key "jobs", "employees"
  add_foreign_key "jobs", "locations"
  add_foreign_key "jobs", "services"
  add_foreign_key "services", "service_categories"
  add_foreign_key "skills", "employees"
  add_foreign_key "skills", "service_categories"
  add_foreign_key "users", "employees"
  add_foreign_key "workplaces", "locations"
end
