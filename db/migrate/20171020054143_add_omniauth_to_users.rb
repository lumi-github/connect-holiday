class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :gender, :integer
    add_column :users, :birthday, :date
    add_column :users, :message, :string
    add_column :users, :comment, :text
    add_column :users, :admin, :boolean
    add_reference :users, :prefecture, foreign_key: true
    add_reference :users, :city, foreign_key: true
  end
end
