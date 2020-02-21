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

ActiveRecord::Schema.define(version: 2020_02_17_232350) do

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
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.bigint "tenant_id"
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
    t.index ["tenant_id"], name: "index_activities_on_tenant_id"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
    t.index ["trackable_type", "trackable_id"], name: "index_activities_on_trackable_type_and_trackable_id"
  end

  create_table "cash_accounts", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "name", limit: 144, null: false
    t.boolean "active", default: true
    t.integer "balance", default: 0, null: false
    t.integer "transactions_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_cash_accounts_on_slug", unique: true
    t.index ["tenant_id"], name: "index_cash_accounts_on_tenant_id"
  end

  create_table "client_tags", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "client_id"
    t.bigint "tag_id"
    t.index ["client_id"], name: "index_client_tags_on_client_id"
    t.index ["tag_id"], name: "index_client_tags_on_tag_id"
    t.index ["tenant_id"], name: "index_client_tags_on_tenant_id"
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "first_name", limit: 144, null: false
    t.string "last_name", limit: 144, null: false
    t.string "phone_number"
    t.string "email"
    t.date "date_of_birth"
    t.string "gender", default: "undisclosed"
    t.string "country"
    t.string "city"
    t.string "zip"
    t.string "address"
    t.string "lead_source", default: "direct"
    t.string "personal_data_consent", default: "t"
    t.string "boolean", default: "t"
    t.string "event_created_notifications", default: "t"
    t.string "marketing_notifications", default: "t"
    t.integer "transactions_sum", default: 0, null: false
    t.integer "event_expences_sum", default: 0, null: false
    t.integer "balance", default: 0, null: false
    t.integer "comments_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.integer "transactions_count", default: 0, null: false
    t.integer "events_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "code"
    t.index ["slug"], name: "index_clients_on_slug", unique: true
    t.index ["tenant_id"], name: "index_clients_on_tenant_id"
  end

  create_table "comments", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "user_id"
    t.text "content"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["tenant_id"], name: "index_comments_on_tenant_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "email"
    t.string "import_id"
    t.string "name"
    t.string "first_name"
    t.string "last_name"
    t.string "address_1"
    t.string "address_2"
    t.string "city"
    t.string "region"
    t.string "postcode"
    t.string "country"
    t.string "phone_number"
    t.string "birthday"
    t.string "gender"
    t.string "relation"
    t.bigint "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contacts_on_client_id"
    t.index ["tenant_id"], name: "index_contacts_on_tenant_id"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "client_id"
    t.datetime "starts_at"
    t.integer "duration", default: 0, null: false
    t.datetime "ends_at"
    t.integer "event_price", default: 0, null: false
    t.integer "event_due_price", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.string "status_color", default: "blue"
    t.text "notes"
    t.integer "jobs_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "workplaces_id"
    t.index ["client_id"], name: "index_events_on_client_id"
    t.index ["slug"], name: "index_events_on_slug", unique: true
    t.index ["tenant_id"], name: "index_events_on_tenant_id"
    t.index ["workplaces_id"], name: "index_events_on_workplaces_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "event_id"
    t.bigint "service_id"
    t.bigint "member_id"
    t.integer "service_duration", default: 0, null: false
    t.integer "service_member_percent", default: 0, null: false
    t.integer "service_client_price", default: 0, null: false
    t.integer "client_price", default: 0, null: false
    t.integer "client_due_price", default: 0, null: false
    t.integer "member_price", default: 0, null: false
    t.integer "member_due_price", default: 0, null: false
    t.integer "add_amount", default: 0, null: false
    t.integer "production_cost", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["event_id"], name: "index_jobs_on_event_id"
    t.index ["member_id"], name: "index_jobs_on_member_id"
    t.index ["service_id"], name: "index_jobs_on_service_id"
    t.index ["slug"], name: "index_jobs_on_slug", unique: true
    t.index ["tenant_id"], name: "index_jobs_on_tenant_id"
  end

  create_table "leads", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "first_name", limit: 144
    t.string "last_name", limit: 144
    t.string "phone_number", limit: 255
    t.string "email", limit: 255
    t.text "comment"
    t.bigint "location_id"
    t.bigint "service_id"
    t.bigint "member_id"
    t.bigint "client_id"
    t.datetime "starts_at"
    t.string "coupon", limit: 144
    t.string "status"
    t.boolean "conditions_consent"
    t.string "referer"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["client_id"], name: "index_leads_on_client_id"
    t.index ["location_id"], name: "index_leads_on_location_id"
    t.index ["member_id"], name: "index_leads_on_member_id"
    t.index ["service_id"], name: "index_leads_on_service_id"
    t.index ["slug"], name: "index_leads_on_slug", unique: true
    t.index ["tenant_id"], name: "index_leads_on_tenant_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "name", limit: 50, null: false
    t.string "phone_number", limit: 144
    t.string "email", limit: 144
    t.string "country"
    t.string "city"
    t.string "zip"
    t.string "address"
    t.string "viber", limit: 40
    t.string "telegram", limit: 40
    t.string "whatsapp", limit: 40
    t.boolean "online_booking", default: true
    t.boolean "active", default: true
    t.integer "locations", default: 0, null: false
    t.integer "members_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.float "latitude"
    t.float "longitude"
    t.index ["slug"], name: "index_locations_on_slug", unique: true
    t.index ["tenant_id"], name: "index_locations_on_tenant_id"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "user_id"
    t.string "first_name", limit: 144
    t.string "last_name", limit: 144
    t.string "phone_number", limit: 255
    t.string "email", limit: 255
    t.date "date_of_birth"
    t.string "gender", default: "undisclosed"
    t.string "country"
    t.string "city"
    t.string "zip"
    t.string "address"
    t.string "time_zone", default: "UTC"
    t.boolean "active", default: true
    t.boolean "online_booking", default: true
    t.integer "balance", default: 0, null: false
    t.integer "transactions_sum", default: 0, null: false
    t.integer "event_earnings_sum", default: 0, null: false
    t.integer "transactions_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.integer "jobs_count", default: 0, null: false
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["location_id"], name: "index_members_on_location_id"
    t.index ["slug"], name: "index_members_on_slug", unique: true
    t.index ["tenant_id"], name: "index_members_on_tenant_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "operating_hours", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "member_id"
    t.integer "day_of_week"
    t.time "closes"
    t.time "opens"
    t.datetime "valid_from"
    t.datetime "valid_through"
    t.index ["member_id"], name: "index_operating_hours_on_member_id"
    t.index ["tenant_id"], name: "index_operating_hours_on_tenant_id"
  end

  create_table "roles", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
    t.index ["tenant_id"], name: "index_roles_on_tenant_id"
  end

  create_table "service_categories", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "name", limit: 144, null: false
    t.integer "services_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_service_categories_on_slug", unique: true
    t.index ["tenant_id"], name: "index_service_categories_on_tenant_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "service_category_id"
    t.string "name", limit: 144, null: false
    t.string "description"
    t.integer "duration", null: false
    t.integer "client_price", default: 0, null: false
    t.integer "member_percent", default: 0, null: false
    t.integer "member_price", default: 0, null: false
    t.integer "jobs_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.boolean "online_booking", default: true
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["service_category_id"], name: "index_services_on_service_category_id"
    t.index ["slug"], name: "index_services_on_slug", unique: true
    t.index ["tenant_id"], name: "index_services_on_tenant_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "skills", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "member_id"
    t.bigint "service_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_skills_on_member_id"
    t.index ["service_category_id"], name: "index_skills_on_service_category_id"
    t.index ["tenant_id"], name: "index_skills_on_tenant_id"
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "name", limit: 40
    t.integer "client_tags_count", default: 0, null: false
    t.index ["name"], name: "index_tags_on_name"
    t.index ["tenant_id"], name: "index_tags_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.bigint "tenant_id"
    t.string "name", limit: 40, null: false
    t.string "subdomain"
    t.string "plan", limit: 40, default: "demo", null: false
    t.string "default_currency", limit: 3, default: "usd", null: false
    t.string "locale", limit: 2, default: "en", null: false
    t.string "industry", limit: 144, default: "other", null: false
    t.string "website", limit: 500
    t.string "description", limit: 500
    t.string "instagram", limit: 40
    t.string "time_zone", default: "UTC"
    t.boolean "online_booking", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["default_currency"], name: "index_tenants_on_default_currency"
    t.index ["locale"], name: "index_tenants_on_locale"
    t.index ["name"], name: "index_tenants_on_name"
    t.index ["plan"], name: "index_tenants_on_plan"
    t.index ["subdomain"], name: "index_tenants_on_subdomain"
    t.index ["tenant_id"], name: "index_tenants_on_tenant_id"
  end

  create_table "tenants_users", id: false, force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "user_id", null: false
    t.index ["tenant_id", "user_id"], name: "index_tenants_users_on_tenant_id_and_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "tenant_id"
    t.integer "amount", default: 0, null: false
    t.integer "payable_id"
    t.string "payable_type"
    t.string "comment", limit: 144
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cash_accounts_id"
    t.index ["cash_accounts_id"], name: "index_transactions_on_cash_accounts_id"
    t.index ["payable_id"], name: "index_transactions_on_payable_id"
    t.index ["payable_type"], name: "index_transactions_on_payable_type"
    t.index ["slug"], name: "index_transactions_on_slug", unique: true
    t.index ["tenant_id"], name: "index_transactions_on_tenant_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "time_zone", default: "UTC"
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "skip_confirm_change_password", default: false
    t.bigint "tenant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["tenant_id"], name: "index_users_on_tenant_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["tenant_id"], name: "index_users_roles_on_tenant_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "workplaces", force: :cascade do |t|
    t.bigint "tenant_id"
    t.bigint "location_id"
    t.string "name", limit: 20, null: false
    t.integer "events_count", default: 0, null: false
    t.integer "integer", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["location_id"], name: "index_workplaces_on_location_id"
    t.index ["slug"], name: "index_workplaces_on_slug", unique: true
    t.index ["tenant_id"], name: "index_workplaces_on_tenant_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "tenants"
  add_foreign_key "cash_accounts", "tenants"
  add_foreign_key "client_tags", "clients"
  add_foreign_key "client_tags", "tags"
  add_foreign_key "client_tags", "tenants"
  add_foreign_key "clients", "tenants"
  add_foreign_key "comments", "tenants"
  add_foreign_key "comments", "users"
  add_foreign_key "contacts", "clients"
  add_foreign_key "contacts", "tenants"
  add_foreign_key "events", "clients"
  add_foreign_key "events", "tenants"
  add_foreign_key "jobs", "events"
  add_foreign_key "jobs", "members"
  add_foreign_key "jobs", "services"
  add_foreign_key "jobs", "tenants"
  add_foreign_key "leads", "clients"
  add_foreign_key "leads", "locations"
  add_foreign_key "leads", "members"
  add_foreign_key "leads", "services"
  add_foreign_key "leads", "tenants"
  add_foreign_key "locations", "tenants"
  add_foreign_key "members", "locations"
  add_foreign_key "members", "tenants"
  add_foreign_key "members", "users"
  add_foreign_key "operating_hours", "tenants"
  add_foreign_key "roles", "tenants"
  add_foreign_key "service_categories", "tenants"
  add_foreign_key "services", "service_categories"
  add_foreign_key "services", "tenants"
  add_foreign_key "skills", "members"
  add_foreign_key "skills", "service_categories"
  add_foreign_key "skills", "tenants"
  add_foreign_key "tags", "tenants"
  add_foreign_key "tenants", "tenants"
  add_foreign_key "transactions", "tenants"
  add_foreign_key "users_roles", "tenants"
  add_foreign_key "workplaces", "locations"
  add_foreign_key "workplaces", "tenants"
end
