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

ActiveRecord::Schema.define(version: 20180325120743) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "builds", force: :cascade do |t|
    t.string "status"
    t.text "configuration"
    t.bigint "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_builds_on_project_id"
  end

  create_table "logs", force: :cascade do |t|
    t.integer "position"
    t.text "content"
    t.string "stage"
    t.string "command"
    t.bigint "build_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["build_id"], name: "index_logs_on_build_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "repo_id"
    t.string "repo_url"
    t.jsonb "deploy_key"
    t.jsonb "webhook"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "access_token"
    t.integer "plan", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
