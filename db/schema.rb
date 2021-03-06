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

ActiveRecord::Schema.define(version: 2021_07_15_034208) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "movies", force: :cascade do |t|
    t.string "imdb_title_id"
    t.string "primary_title", null: false
    t.string "original_title", null: false
    t.integer "start_year"
    t.integer "end_year"
    t.integer "runtime_minutes"
    t.string "genres", array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["primary_title", "id"], name: "index_movies_on_primary_title_and_id"
    t.index ["start_year", "id"], name: "index_movies_on_start_year_and_id", order: { start_year: "DESC NULLS LAST" }
  end

end
