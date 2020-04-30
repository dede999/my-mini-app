# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :lists, dependent: :delete_all
  has_many :likes, dependent: :delete_all
  has_many :tasks, through: :lists, dependent: :delete_all

  def followed_lists
    self.likes.collect { |like| like.list }
  end
end
