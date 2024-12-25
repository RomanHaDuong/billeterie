class AddStatutToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :statut, :string
  end
end
