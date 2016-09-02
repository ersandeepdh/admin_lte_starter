class AddTimeStemp < ActiveRecord::Migration
  def change
  	add_column :job_posts, :timestamp, :string
  end
end
