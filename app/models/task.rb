class Task < ApplicationRecord
  has_many :child_tasks, class_name: 'Task',
           foreign_key: 'parent_id'

  belongs_to :list
  belongs_to :parent, class_name: 'Task', optional: true
  validates :title, length: { minimum: 5 }

end
