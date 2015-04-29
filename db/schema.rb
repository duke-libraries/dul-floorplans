# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150410201028) do

  create_table "buildings", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "label",      limit: 255, null: false
    t.string   "sublabel",   limit: 255
    t.boolean  "active",     limit: 1
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "buildings", ["name"], name: "index_buildings_on_name", using: :btree

  create_table "floor_areas", force: :cascade do |t|
    t.string   "coord",        limit: 750
    t.string   "shape",        limit: 255
    t.integer  "floorplan_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "floor_areas", ["floorplan_id"], name: "index_floor_areas_on_floorplan_id", using: :btree
  add_index "floor_areas", ["shape"], name: "index_floor_areas_on_shape", using: :btree

  create_table "floorplan_maps", force: :cascade do |t|
    t.string   "label",      limit: 255
    t.string   "image_url",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "floorplan_maps", ["label"], name: "index_floorplan_maps_on_label", using: :btree

  create_table "floorplans", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "label",            limit: 255
    t.string   "sublabel",         limit: 255
    t.integer  "building_id",      limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "floorplan_map_id", limit: 4
  end

  add_index "floorplans", ["building_id"], name: "index_floorplans_on_building_id", using: :btree
  add_index "floorplans", ["floorplan_map_id"], name: "index_floorplans_on_floorplan_map_id", using: :btree
  add_index "floorplans", ["name"], name: "index_floorplans_on_name", using: :btree

  create_table "room_areas", force: :cascade do |t|
    t.string   "coord",      limit: 750
    t.string   "shape",      limit: 255
    t.integer  "room_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "room_areas", ["room_id"], name: "index_room_areas_on_room_id", using: :btree
  add_index "room_areas", ["shape"], name: "index_room_areas_on_shape", using: :btree

  create_table "room_mockup_images", force: :cascade do |t|
    t.integer  "room_id",        limit: 4
    t.integer  "room_mockup_id", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "room_mockup_images", ["room_id"], name: "index_room_mockup_images_on_room_id", using: :btree
  add_index "room_mockup_images", ["room_mockup_id"], name: "index_room_mockup_images_on_room_mockup_id", using: :btree

  create_table "room_mockups", force: :cascade do |t|
    t.string   "label",      limit: 255
    t.string   "image",      limit: 750
    t.integer  "room_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "room_mockups", ["room_id"], name: "index_room_mockups_on_room_id", using: :btree

  create_table "rooms", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "room_number",        limit: 255
    t.string   "label",              limit: 255
    t.integer  "floorplan_id",       limit: 4
    t.boolean  "naming_opportunity", limit: 1
    t.boolean  "nameable",           limit: 1
    t.integer  "dollar_amount",      limit: 4
    t.boolean  "pending_sale",       limit: 1
    t.boolean  "carrel",             limit: 1
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "rooms", ["floorplan_id"], name: "index_rooms_on_floorplan_id", using: :btree
  add_index "rooms", ["name"], name: "index_rooms_on_name", using: :btree

  add_foreign_key "floor_areas", "floorplans"
  add_foreign_key "floorplans", "buildings"
  add_foreign_key "floorplans", "floorplan_maps"
  add_foreign_key "room_areas", "rooms"
  add_foreign_key "room_mockup_images", "room_mockups"
  add_foreign_key "room_mockup_images", "rooms"
  add_foreign_key "room_mockups", "rooms"
  add_foreign_key "rooms", "floorplans"
end
