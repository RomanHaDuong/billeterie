class OffreFournisseur < ApplicationRecord
  belongs_to :offre
  belongs_to :fournisseur
  
  validates :fournisseur_id, uniqueness: { scope: :offre_id }
end
