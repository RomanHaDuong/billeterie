class AddAutreInfoDateToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :autre_info_date, :string
  end
end
