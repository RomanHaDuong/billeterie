class AddOffinityToFournisseurs < ActiveRecord::Migration[7.1]
  def change
    add_column :fournisseurs, :offinity, :string
  end
end
