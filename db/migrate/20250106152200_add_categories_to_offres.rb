class AddCategoriesToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :categories, :string
  end
end
