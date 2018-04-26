class Admin::WorksController < ApplicationController

  def event_make_csv
    #prefectures = Prefecture.all
    cities = City.all

    #prefecture(from 8 to 15) city(10) event(5) category(5random) day(5random) time(固定) user*(6random)
    #prefecture, city, event, #同一 category, day, user

    File.open("event.csv", "w") do |f|

      num = 1

      for pref_id in 8 .. 30 do

        cities = City.where(prefecture_id: pref_id)

=begin
        if pref_id != 15
          cities = City.where(prefecture_id: pref_id).limit(10)
        else
          cities = City.where(prefecture_id: pref_id)
        end
=end
        cities.each do |city|

          #event作成
          for event_no in 1 .. 5 do

            title = "イベント名#{num}"
            content = "メモメモメモメモメモメモ"
            day = rand(1..28)
            start_datetime = "2017-12-#{day} 00:00:00"
            end_datetime = "2017-12-#{day} 23:59:59"
            accept_user_limit = rand(1..10)

            random_num = rand(1..3)

            case random_num
            when 1 then
              price = 500
            when 2 then
              price = 1000
            when 3 then
              price = 3000
            else
              price = 0
            end

            has_tag = "タグ"
            movie = "https://test.movie"
            place = "場所"
            latitude = "123.11"
            longitude = "333.11"
            state = 0
            user_id = rand(1..5)
            prefecture_id = pref_id
            city_id = city.id
            category_id = rand(1..5)

            f.puts("#{title},#{content},#{start_datetime},#{end_datetime},#{accept_user_limit},#{price},#{has_tag},#{movie},#{place},#{latitude},#{longitude},#{state},#{user_id},#{prefecture_id},#{city_id},#{category_id}")

            num = num + 1

          end

        end
      end

      #prefecture.cities.each do |val|
      #  f.puts(val.eigo_name.to_roma)
      #end

    end

  end

end
