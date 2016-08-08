# t.string   "permalink",  limit: 255
# t.text     "title",      limit: 65535
# t.text     "content",    limit: 65535
# t.integer  "view_count", limit: 4
# t.datetime "created_at",               null: false
# t.datetime "updated_at",               null: false
class JobPost < ActiveRecord::Base
 has_many :post_links, dependent: :destroy
end