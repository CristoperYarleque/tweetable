class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: [:github]
  # associations
  has_many :tweets, through: :likes
  has_many :likes, dependent: :destroy
  has_one_attached :avatar

  # validations
  validates :name, :username, presence: true
  validates :username, uniqueness: true
  enum role: { member: 0, admin: 1 }

  def self.from_omniauth(auth_hash)
    where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create do |user|
      user.provider = auth_hash.provider
      user.uid = auth_hash.uid
      user.username = auth_hash.info.nickname
      user.name = auth_hash.info.name
      user.email = auth_hash.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  # methods for token
  has_secure_token

  def invalidate_token
    update(token: nil)
  end
end
