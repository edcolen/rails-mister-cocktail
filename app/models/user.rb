class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # after_create :set_default_avatar

  has_many :cocktails, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_one_attached :photo

  validates :username,
            presence: true,
            format: { with: /\A(?=[a-zA-Z0-9._-]{5,20}$)(?!.*[_.]{2})[^_.].*[^_.]\z/,
                      message: 'username should have between 5 and 20 valid characters (a-z, 0-9, ".", "_" or "-")' }
  validates :email, :password, presence: true

  # def set_default_avatar
  #   unless photo.attached?
  #     avatar_url = "https://api.adorable.io/avatars/285/#{id}ollivia.png"
  #     avatar = URI.open(avatar_url)
  #     photo.attach(io: avatar, filename: "#{username}.png", content_type: 'image/png')
  #   end
  # end
end
