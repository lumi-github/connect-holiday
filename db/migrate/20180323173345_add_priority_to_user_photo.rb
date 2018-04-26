class AddPriorityToUserPhoto < ActiveRecord::Migration[5.0]
  def change
    add_column :user_photos, :priority, :boolean, default:false
  end
end
