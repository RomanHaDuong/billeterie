class AddPlaceToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :place, :integer
  end
end
