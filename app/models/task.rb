class Task < ApplicationRecord
  belongs_to :list
  validates :title, length: { minimum: 5 }

  def child_tasks
    Task.where(parent_id: self.id)
  end
end
