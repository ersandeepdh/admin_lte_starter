class CreateJobPosts < ActiveRecord::Migration
  def change
    create_table :job_posts do |t|
      t.string :permalink 
      t.text :title
      t.text :content
      t.integer :view_count


      t.timestamps null: false
    end

    create_table :post_links do |t|
      t.string :link_text
      t.integer :job_post_id

      t.timestamps null: false
    end
  end
end
