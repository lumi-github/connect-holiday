class Event < ApplicationRecord

  require 'aws-sdk'

  has_many :event_photos, dependent: :destroy
  accepts_nested_attributes_for :event_photos

  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  belongs_to :prefecture
  belongs_to :city
  belongs_to :category

  has_many :books, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  #validates :start_datetime, presence: true
  #validates :end_datetime, presence: true

  validate :event_date
  def event_date
    if !start_datetime.present?
      errors.add(:start_datetime, 'を入力してください')
    end

    if !end_datetime.present?
      errors.add(:end_datetime, 'を入力してください')
    end

    if start_datetime.present? && end_datetime.present? && start_datetime > end_datetime
      errors.add(:start_datetime, ':正しい時刻を入力してください')
    end
  end

  validates :accept_user_limit, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :place, presence: true, length: { maximum: 255 }
  validates :content, length: { maximum: 1000 }
  validates :prefecture, presence: true
  validates :city, presence: true
  validates :category, presence: true

end
