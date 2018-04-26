class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :content
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.integer :accept_user_limit
      t.integer :price
      t.string :hash_tag
      t.string :movie
      t.string :place
      t.float :latitude
      t.float :longitude
      t.boolean :state, default: false
      t.references :user, foreign_key: true
      t.references :prefecture, foreign_key: true
      t.references :city, foreign_key: true
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
