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

ActiveRecord::Schema.define(version: 2020_02_18_093216) do

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.string "roles"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_admins_on_username"
  end

  create_table "departments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "parent_id", default: 0, null: false
    t.string "name"
    t.integer "category", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "master_id"
    t.index ["master_id"], name: "index_departments_on_master_id"
    t.index ["parent_id"], name: "index_departments_on_parent_id"
  end

  create_table "positions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "record_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "record_id"
    t.integer "kind", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_id"], name: "index_record_logs_on_record_id"
  end

  create_table "records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "user_id"
    t.integer "approver_id"
    t.integer "status", default: 0
    t.datetime "begin_at"
    t.datetime "end_at"
    t.string "address"
    t.string "tel"
    t.text "cause"
    t.string "agent"
    t.string "agent_office"
    t.string "agent_office_tel"
    t.string "agent_mobile"
    t.datetime "back_at"
    t.text "exdata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agent"], name: "index_records_on_agent"
    t.index ["approver_id"], name: "index_records_on_approver_id"
    t.index ["begin_at"], name: "index_records_on_begin_at"
    t.index ["end_at"], name: "index_records_on_end_at"
    t.index ["user_id"], name: "index_records_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "position_id"
    t.integer "department_id"
    t.string "realname"
    t.string "mobile"
    t.string "nickname"
    t.string "avatar"
    t.string "password_digest"
    t.string "job"
    t.boolean "bind_wechat", default: false, null: false
    t.text "exdata"
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["mobile"], name: "index_users_on_mobile", unique: true
    t.index ["position_id"], name: "index_users_on_position_id"
    t.index ["realname"], name: "index_users_on_realname"
  end

  create_table "vote_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "mobile"
    t.string "code"
    t.string "kind"
    t.integer "department_id"
    t.text "ua"
    t.string "ip"
    t.datetime "vote_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_vote_members_on_code", unique: true
    t.index ["department_id"], name: "index_vote_members_on_department_id"
  end

  create_table "vote_results", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "kind"
    t.integer "department_id"
    t.integer "user_id"
    t.string "code"
    t.integer "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_vote_results_on_department_id"
    t.index ["kind"], name: "index_vote_results_on_kind"
    t.index ["user_id"], name: "index_vote_results_on_user_id"
  end

  create_table "wechat_sessions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "openid", null: false
    t.string "hash_store"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["openid"], name: "index_wechat_sessions_on_openid", unique: true
    t.index ["user_id"], name: "index_wechat_sessions_on_user_id"
  end

end
