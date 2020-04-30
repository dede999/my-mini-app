class CreateLists < ActiveRecord::Migration[5.2]
  def change
    create_table :lists do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.string :is_private, default: false
      t.text :description

      t.timestamps
    end
  end
end
