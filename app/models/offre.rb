class Offre < ApplicationRecord
  belongs_to :fournisseur
  has_many :favoris
  has_many :favori_users, through: :favoris, source: :user
  has_one_attached :image
end
