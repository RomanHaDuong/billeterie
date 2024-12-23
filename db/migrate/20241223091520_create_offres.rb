class CreateOffres < ActiveRecord::Migration[7.1]
  def change
    create_table :offres do |t|
      t.integer :price
      t.references :fournisseur, null: false, foreign_key: true

      t.timestamps
    end
  end
end
