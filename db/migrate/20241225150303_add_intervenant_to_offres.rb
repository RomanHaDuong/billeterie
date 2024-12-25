class AddIntervenantToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :intervenant, :string
  end
end
