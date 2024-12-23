class User < ApplicationRecord

  has_many :favoris
  has_many :favori_offres, through: :favoris, source: :offre

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
