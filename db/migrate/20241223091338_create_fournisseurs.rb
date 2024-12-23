class CreateFournisseurs < ActiveRecord::Migration[7.1]
  def change
    create_table :fournisseurs do |t|
      t.string :bio
      t.references :user, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
