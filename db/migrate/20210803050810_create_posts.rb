class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :user_id
      t.string :category_id
      t.string :image_id
      t.text :introduction
      t.string :address
      t.float :latitude
      t.float :longitude
      t.datetime :start_time

      t.timestamps
    end
  end
end
