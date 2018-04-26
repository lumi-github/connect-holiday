class AddNoticeTimeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :notice_time, :integer
  end
end
