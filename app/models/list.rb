class List < ApplicationRecord
  has_many :tasks, dependent: :delete_all
  has_many :likes, dependent: :delete_all

  belongs_to :user
  accepts_nested_attributes_for :tasks

  def first_level_children
    self.tasks.where(parent_id: nil)
  end
end
