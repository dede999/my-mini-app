class TaskController < ApplicationController
  before_action :set_list, only: [:index, :create]
  before_action :set_task, only: [:show, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    render json: @list.first_level_children
  end

  def show
    render json: {
        task: @task,
        child: @task.child_tasks
    }
  end

  def create
    if @list.user == current_user
      @task = Task.new(task_params)
      @task.list = @list

      if @task.save
        render json: @task, status: :created, location: @task
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    else
      render status: :unauthorized
    end
  end

  def update
    if @task.list.user == current_user
      if @task.update(task_params)
        render json: @task, status: :ok
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    else
      render status: :unauthorized
    end
  end

  def destroy
    if @task.list.user == current_user
      @task.destroy
      render status: :no_content
    else
      render status: :unauthorized
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  def set_list
    @list = List.find(params[:list_id])
  end

  # Only allow a trusted parameter "white list" through.
  def task_params
    params.require(:task)
        .permit(:title, :parent_id, :is_complete)
  end
end
