class AddValeurApporteeToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :valeur_apportee, :string
  end
end
