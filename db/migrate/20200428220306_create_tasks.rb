class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :title
      t.references :list, foreign_key: true
      t.references :parent
      t.boolean :is_complete, default: 0

      t.timestamps
    end
  end
end
