class CreateHolidays < ActiveRecord::Migration[5.0]
  def change
    create_table :holidays do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.boolean  :allday
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
