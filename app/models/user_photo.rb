class UserPhoto < ApplicationRecord

  belongs_to :user

  default_scope -> { order(priority: :desc) }

  has_attached_file :image,
                    :storage => :s3,
                    :s3_permissions => "public-read",
                    :s3_credentials => "/config/s3.yml",
                    #:s3_credentials => "#{Rails.root}/config/s3.yml",

                    #:path => "/system/:hash.:extension",
                    :path => ":class/:id/:attachment/:style/:hash.:extension",
                    :hash_secret => "UserphotoSUploaD",
                    #:hash_secret => SecureRandom.hex(64),

                    #:path => ":class/:id/:attachment/:style/:filename",
                    :styles => {
                      default_url: '/images/no_image.png',
                      :original => '1980x1680>',
                      :medium => '300x300>',
                      :thumb => '100x100#'
                    }

                    validates_attachment :image, presence: true,

                    #content_type: { content_type: "image/jpeg" },
                    size: { in: 0..2000.kilobytes }

  do_not_validate_attachment_file_type :image

end
