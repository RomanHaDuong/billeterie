class AddTitreToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :titre, :string
  end
end
