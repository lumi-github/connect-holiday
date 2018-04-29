require "csv"

#CSV.foreach('db/csv/prefecture.csv') do |row|
#  Prefecture.create(:name => row[0], :eigo_name => row[1], :furigana => row[2])
#end

#CSV.foreach('db/csv/city.csv') do |row|
#  City.create(:id => row[0], :name => row[1], :eigo_name => row[2], :furigana => row[3], :prefecture_id => row[4], :state => row[5])
#end

#Category.create(:name => '趣味', :state => 0)
#Category.create(:name => 'スポーツ', :state => 0)
#Category.create(:name => 'グルメ', :state => 0)
#Category.create(:name => '学習', :state => 0)
#Category.create(:name => 'ボランティア', :state => 0)

#CSV.foreach('db/csv/holiday.csv') do |row|
#  Holiday.create(:start_datetime => row[0], :end_datetime => row[1], :allday => row[2], :user_id => row[3])
#end


CSV.foreach('db/csv/event.csv') do |row|
  Event.create(:title => row[0], :content => row[1], :start_datetime => row[2], :end_datetime => row[3], :accept_user_limit => row[4], :price => row[5], :hash_tag => row[6], :movie => row[7], :place => row[8], :latitude => row[9], :longitude => row[10], :state => row[11], :user_id => row[12], :prefecture_id => row[13], :city_id => row[14], :category_id => row[15])
end
