class Task < ApplicationRecord
  has_many :child_tasks, class_name: 'Task',
           foreign_key: 'parent_id', dependent: destroy_all

  belongs_to :list
  belongs_to :parent, class_name: 'Task', optional: true

  validates :title, length: { minimum: 5 }
  before_destroy :do_before_delete

  def manage_parent
    if !self.parent.nil? and self.check_parent_state
      self.parent.is_complete = true
      self.parent.manage_parent
    end
  end

  def manage_children(state = self.is_complete)
    if state
      self.child_tasks.each { |task| task.close_children }
    end
  end

  def close_children
    self.is_complete = true
    self.save
    self.child_tasks.each { |task| task.close_children }
  end

  def check_parent_state
    state = true
    self.parent.child_tasks.each { |task| task.is_complete and state }
    state
  end

  def do_before_delete
    self.is_complete = true
    self.save
    self.manage_parent
  end
end
