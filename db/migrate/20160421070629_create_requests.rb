class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.text :params_txt
      t.string :utm_source
      t.string :utm_ip
      t.string :utm_referer

      t.timestamps null: false
    end
  end
end
