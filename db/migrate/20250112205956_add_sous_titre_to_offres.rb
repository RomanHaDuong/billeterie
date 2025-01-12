class AddSousTitreToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :sous_titre, :string
  end
end
