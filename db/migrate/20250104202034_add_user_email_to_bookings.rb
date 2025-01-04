class AddUserEmailToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :user_email, :string
  end
end
