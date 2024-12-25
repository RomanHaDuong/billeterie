class AddDescriptifToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :descriptif, :string
  end
end
