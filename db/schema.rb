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

ActiveRecord::Schema.define(version: 2020_03_16_194520) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "data_points", force: :cascade do |t|
    t.bigint "zone_id"
    t.integer "value"
    t.integer "diff_with_previous_date"
    t.integer "category"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category"], name: "index_data_points_on_category"
    t.index ["date"], name: "index_data_points_on_date"
    t.index ["zone_id"], name: "index_data_points_on_zone_id"
  end

  create_table "geojson_features", force: :cascade do |t|
    t.bigint "zone_id"
    t.json "feature"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["zone_id"], name: "index_geojson_features_on_zone_id"
  end

  create_table "zones", force: :cascade do |t|
    t.integer "nature"
    t.string "kebab_name"
    t.string "name"
    t.string "abbreviation"
    t.string "code"
    t.float "lat"
    t.float "lng"
    t.integer "population"
    t.bigint "parent_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["kebab_name"], name: "index_zones_on_kebab_name"
    t.index ["parent_id"], name: "index_zones_on_parent_id"
  end

end
