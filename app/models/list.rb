class List < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :delete_all
  accepts_nested_attributes_for :tasks

  def first_level_children
    self.tasks.where(parent_id: -1)
  end
end
