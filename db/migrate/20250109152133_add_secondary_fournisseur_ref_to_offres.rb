class AddSecondaryFournisseurRefToOffres < ActiveRecord::Migration[7.1]
  def change
    add_reference :offres, :secondary_fournisseur, foreign_key: { to_table: :fournisseurs }, null: true
  end
end
