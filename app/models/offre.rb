class Offre < ApplicationRecord
  belongs_to :fournisseur
  belongs_to :secondary_fournisseur, class_name: 'Fournisseur', optional: true

  has_many :favoris
  has_many :favori_users, through: :favoris, source: :user
  has_many :bookings
  has_one_attached :image
end
