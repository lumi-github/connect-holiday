class Admin::CitiesController < ApplicationController

  require 'romkan'

  def eigo_make_csv
    prefectures = Prefecture.all

    File.open("cities.txt", "w") do |f|

      prefectures.each do |prefecture|
        prefecture.cities.each do |val|
          f.puts(val.eigo_name.to_roma)
        end
      end

    end

  end

end
