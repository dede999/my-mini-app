class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.references :list, foreign_key: true
      t.integer :parent_id, default: -1
      t.boolean :is_complete

      t.timestamps
    end
  end
end
