class AddUserNameToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :user_name, :string
  end
end
