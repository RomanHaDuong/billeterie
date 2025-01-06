class AddSalleToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :salle, :string
  end
end
