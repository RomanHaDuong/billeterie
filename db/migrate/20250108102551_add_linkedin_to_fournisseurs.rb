class AddLinkedinToFournisseurs < ActiveRecord::Migration[7.1]
  def change
    add_column :fournisseurs, :linkedin, :string
  end
end
