class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.boolean :is_private, default: 0
      t.text :description

      t.timestamps
    end
  end
end
