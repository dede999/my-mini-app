class List < ApplicationRecord
  has_many :likes, dependent: :delete_all
  has_many :tasks, dependent: :delete_all
  accepts_nested_attributes_for :tasks

  belongs_to :user

  validates :title, length: { minimum: 15 }
  validates :title, uniqueness: { scope: :user_id }

  def first_level_children
    self.tasks.where(parent_id: nil)
  end
end
