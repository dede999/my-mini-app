class Task < ApplicationRecord
  has_many :child_tasks, class_name: 'Task',
           foreign_key: 'parent_id', dependent: :delete_all
  accepts_nested_attributes_for :child_tasks

  belongs_to :list
  belongs_to :parent, class_name: 'Task', optional: true

  validates :title, length: { minimum: 15 }
  validates :title, uniqueness: { scope: :list }

  after_update :manage_parent
  after_update :manage_children, if: :is_complete?

  def manage_parent
    if !self.parent.nil? && check_parent_state
      self.parent.is_complete = true
      self.parent.save
    end
  end

  def manage_children
    if is_complete
      self.child_tasks.each { |task| task.close_children }
    end
  end

  def close_children
    return if is_complete == true
    self.is_complete = true
    self.save
    self.child_tasks.each { |task| task.close_children }
  end

  def check_parent_state
    state = true
    self.parent.child_tasks.each { |task| task.is_complete and state }
    state
  end
end
