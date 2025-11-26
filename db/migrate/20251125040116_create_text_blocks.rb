class CreateTextBlocks < ActiveRecord::Migration[7.1]
  def change
    create_table :text_blocks do |t|
      t.string :key
      t.text :content

      t.timestamps
    end
  end
end
