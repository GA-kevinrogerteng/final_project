class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :fb_id
      t.string :fb_type
      t.string :link
      t.string :story
      t.string :message
      t.datetime :created_time
      t.datetime :updated_time
      t.string :fb_uid
      t.string :fb_uid_from
      t.string :picture
      t.string :icon
      t.string :name
      t.string :object_id
      t.string :category

      t.timestamps
    end
  end
end
