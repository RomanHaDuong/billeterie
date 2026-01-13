class Fournisseur < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :image
  has_many :offres
  has_many :secondary_offres, class_name: 'Offre', foreign_key: 'secondary_fournisseur_id'
  has_many :offre_fournisseurs, dependent: :destroy
  has_many :additional_offres, through: :offre_fournisseurs, source: :offre
end
