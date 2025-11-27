class User < ApplicationRecord
  has_one_attached :image
  has_many :favoris
  has_many :bookings
  has_many :favori_offres, through: :favoris, source: :offre

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         # :omniauthable, omniauth_providers: [:google_oauth2]

  # Disabled OmniAuth for now
  # def self.from_google_oauth2(auth)
  #   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  #     user.email = auth.info.email
  #     user.password = Devise.friendly_token[0, 20]
  #     user.name = auth.info.name
  #
  #     if auth.info.image.present?
  #       downloaded_image = URI.open(auth.info.image)
  #       user.image.attach(io: downloaded_image, filename: "profile.jpg")
  #     end
  #
  #     user.google_token = auth.credentials.token
  #     user.google_refresh_token = auth.credentials.refresh_token
  #   end
  # end
end
