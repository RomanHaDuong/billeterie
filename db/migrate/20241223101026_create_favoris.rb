class CreateFavoris < ActiveRecord::Migration[7.1]
  def change
    create_table :favoris do |t|
      t.references :user, null: false, foreign_key: true
      t.references :offre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
