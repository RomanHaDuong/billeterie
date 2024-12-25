class AddAutreCommentaireToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :autre_commentaire, :string
  end
end
