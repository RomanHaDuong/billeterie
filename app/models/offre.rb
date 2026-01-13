class Offre < ApplicationRecord
  belongs_to :fournisseur
  belongs_to :secondary_fournisseur, class_name: 'Fournisseur', optional: true

  has_many :offre_fournisseurs, dependent: :destroy
  has_many :additional_fournisseurs, through: :offre_fournisseurs, source: :fournisseur

  has_many :favoris
  has_many :favori_users, through: :favoris, source: :user
  has_many :bookings, dependent: :destroy
  has_many :registered_users, through: :bookings, source: :user
  has_one_attached :image

  validate :maximum_five_animateurs

  validates :titre, presence: true
  validates :descriptif, presence: true
  validates :place, presence: true, numericality: { greater_than: 0 }
  validates :date_prevue, presence: true

  # Check if there are available spots
  def available_spots
    return nil if place.nil?
    place - bookings.count
  end

  def spots_available?
    place.nil? || available_spots > 0
  end

  def full?
    !spots_available?
  end

  # Check if a user is registered
  def user_registered?(user)
    return false unless user
    bookings.exists?(user_id: user.id)
  end

  # Get all animateurs for this offre
  def all_animateurs
    animateurs = [fournisseur]
    animateurs << secondary_fournisseur if secondary_fournisseur.present?
    animateurs + additional_fournisseurs.to_a
  end

  # Setter for additional_fournisseur_ids to handle form input
  def additional_fournisseur_ids=(ids)
    ids = ids.reject(&:blank?) if ids.is_a?(Array)
    self.additional_fournisseurs = Fournisseur.where(id: ids)
  end

  private

  def maximum_five_animateurs
    total = 1 # Primary fournisseur
    total += 1 if secondary_fournisseur_id.present?
    total += additional_fournisseurs.count
    
    if total > 5
      errors.add(:base, "Un atelier ne peut pas avoir plus de 5 animateurs")
    end
  end
end
