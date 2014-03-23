class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :friends
      t.string :fb_id
      t.string :gender
      t.string :hometown
      t.boolean :installed
      t.string :language
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :locale
      t.string :name
      t.string :name_format
      t.string :political
      t.string :relationship_status
      t.string :religion

      t.timestamps
    end
  end
end
