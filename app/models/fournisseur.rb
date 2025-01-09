class Fournisseur < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :offres
  has_many :secondary_offres, class_name: 'Offre', foreign_key: 'secondary_fournisseur_id'
end
