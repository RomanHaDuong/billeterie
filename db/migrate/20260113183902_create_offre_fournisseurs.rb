class CreateOffreFournisseurs < ActiveRecord::Migration[7.1]
  def change
    create_table :offre_fournisseurs do |t|
      t.references :offre, null: false, foreign_key: true
      t.references :fournisseur, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :offre_fournisseurs, [:offre_id, :fournisseur_id], unique: true
  end
end
