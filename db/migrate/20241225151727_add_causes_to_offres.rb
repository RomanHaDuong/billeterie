class AddCausesToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :causes, :string
  end
end
