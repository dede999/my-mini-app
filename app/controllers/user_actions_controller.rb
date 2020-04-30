class UserActionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_follow, except: :show_followed_lists

  def follow_a_list
    list = List.find(params[:list_id])
    if @follow.empty?
      @like = Like.new(user: current_user, list: list)
      if @like.save
        render json: {
            msg: "User ##{current_user.id} is following list ##{list.id}"
        }, status: :created, location: @like
      else
        render json: @like.errors, status: :unprocessable_entity
      end
    end
  end

  def unfollow_a_list
    unless @follow.empty?
      @follow.first.destroy
      render status: :no_content
    end
  end

  def show_followed_lists
    render json: current_user.followed_lists, status: :ok
  end

  private

  def check_follow
    list = List.find(params[:list_id])
    @follow = Like.where(user: current_user, list: list)
  end
end
