class AddBesoinLogistiqueToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :besoin_logistique, :string
  end
end
