class AddCibleToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :cible, :string
  end
end
