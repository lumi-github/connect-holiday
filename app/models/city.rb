class City < ApplicationRecord
  belongs_to :prefecture, class_name: 'Prefecture', foreign_key: 'prefecture_id'
end
