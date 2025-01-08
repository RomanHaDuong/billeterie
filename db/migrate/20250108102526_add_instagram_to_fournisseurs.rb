class AddInstagramToFournisseurs < ActiveRecord::Migration[7.1]
  def change
    add_column :fournisseurs, :instagram, :string
  end
end
