class Fournisseur < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :offres
end
