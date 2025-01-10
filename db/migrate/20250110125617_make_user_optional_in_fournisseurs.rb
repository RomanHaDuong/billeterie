class MakeUserOptionalInFournisseurs < ActiveRecord::Migration[7.1]
  def change
    change_column_null :fournisseurs, :user_id, true
  end
end
