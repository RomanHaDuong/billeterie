class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :offre

  scope :future, -> { joins(:offre).where('offres.date_prevue > ?', DateTime.now) }
end
