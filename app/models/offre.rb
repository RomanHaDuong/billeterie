class Offre < ApplicationRecord
  belongs_to :fournisseur
  belongs_to :secondary_fournisseur, class_name: 'Fournisseur', optional: true

  has_many :favoris
  has_many :favori_users, through: :favoris, source: :user
  has_many :bookings, dependent: :destroy
  has_many :registered_users, through: :bookings, source: :user
  has_one_attached :image

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
end
