class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.string :type
      t.references :user, foreign_key: true
      t.references :target, foreign_key: {to_table: :users}
      t.boolean :state

      t.timestamps

      t.index [:user_id, :target_id, :type], unique: true
    end
  end
end
