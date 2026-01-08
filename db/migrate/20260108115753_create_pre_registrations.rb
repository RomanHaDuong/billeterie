class CreatePreRegistrations < ActiveRecord::Migration[7.1]
  def change
    create_table :pre_registrations do |t|
      t.string :email
      t.string :role

      t.timestamps
    end
  end
end
