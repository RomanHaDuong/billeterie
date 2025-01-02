class AddCreneauToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :creneau, :integer
  end
end
