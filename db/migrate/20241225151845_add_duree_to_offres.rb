class AddDureeToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :duree, :string
  end
end
