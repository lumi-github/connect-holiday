class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :name
      t.string :eigo_name
      t.string :furigana
      t.boolean :state
      t.references :prefecture, foreign_key: true

      t.timestamps
    end
  end
end
