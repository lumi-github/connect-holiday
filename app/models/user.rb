class User < ApplicationRecord

  require 'aws-sdk'

  has_many :user_photos, dependent: :destroy
  accepts_nested_attributes_for :user_photos

  #userの作成したイベントリストを取得する
  has_many :events, dependent: :destroy

  #user参加するイベントリストを取得する
  has_many :books, dependent: :destroy

  #userの休日情報
  has_many :holidays, dependent: :destroy

  has_many :follows
  has_many :follow_users, through: :follows, class_name: 'User', source: :target

  has_many :blocks
  has_many :block_users, through: :blocks, class_name: 'User', source: :target

  has_many :relationships
  has_many :reverse_of_relationship, class_name: 'Relationship', foreign_key: 'target_id'

  validates_uniqueness_of :name, :message => 'が既に登録されています。 別の名前を入力して下さい。'

  #validate :add_error_message
  # 名前はユニークか
  #def add_error_message
  #  if !name.uniqueness?
  #    errors[:base] << "入力した名前は既に登録されています。"
  #  end
  #end

  def follow(other_user)
    unless self == other_user
      # ブロックしている場合は、typeがBlockのレコードを削除
      block = self.blocks.find_by(target_id: other_user.id)
      block.destroy if block
      self.follows.find_or_create_by(target_id: other_user.id)
    end
  end

  def unfollow(other_user)
    follow = self.follows.find_by(target_id: other_user.id)
    follow.destroy if follow
  end

  def follow?(other_user)
    self.follow_users.include?(other_user)
  end

  def block(other_user)
    # フォローしている場合は、typeがFollowのレコードを削除
    follow = self.follows.find_by(target_id: other_user.id)
    follow.destroy if follow
    self.blocks.find_or_create_by(target_id: other_user.id)
  end

  def unblock(other_user)
    block = self.blocks.find_by(target_id: other_user.id)
    block.destroy if block
  end

  def block?(other_user)
    self.block_users.include?(other_user)
  end

  def connected?
    !stripe_user_id.nil?
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:facebook]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
#      user.image = auth.info.image # assuming the user model has an image
    end
  end
end
