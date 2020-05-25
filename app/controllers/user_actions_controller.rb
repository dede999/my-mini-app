class UserActionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_follow, except: [:show_followed_lists, :edit_user]

  def follow_a_list
    list = List.find(params[:list_id])
    if @follow.empty?
      @like = Like.new(user: current_user, list: list)
      if @like.save
        render json: @like, status: :created
      else
        render json: @like.errors.messages, status: :unprocessable_entity
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

  def edit_user
    if current_user.update(user_params)
      render json: current_user, status: :ok
    else
      render json: current_user.errors.messages, status: :unprocessable_entity
    end
  end

  private

  def check_follow
    list = List.find(params[:list_id])
    @follow = Like.where(user: current_user, list: list)
  end

  def user_params
    params.require(:user).permit(:name, :nickname, :email)
  end
end
