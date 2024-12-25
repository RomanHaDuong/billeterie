class AddIntentionToOffres < ActiveRecord::Migration[7.1]
  def change
    add_column :offres, :intention, :string
  end
end
