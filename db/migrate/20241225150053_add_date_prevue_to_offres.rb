class AddDatePrevueToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :date_prevue, :date
  end
end
