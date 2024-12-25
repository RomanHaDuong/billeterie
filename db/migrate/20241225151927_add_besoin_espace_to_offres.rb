class AddBesoinEspaceToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :besoin_espace, :string
  end
end
