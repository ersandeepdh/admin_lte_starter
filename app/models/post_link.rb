# t.string   "link_text",   limit: 255
# t.integer  "job_post_id", limit: 4
# t.datetime "created_at",              null: false
# t.datetime "updated_at",              null: false

class PostLink < ActiveRecord::Base
  belongs_to :job_post
end
